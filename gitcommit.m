function gitcommit(message)
    %---------------------------%
    %  Auto-update GitCommit.m  %
    %---------------------------%
%     gitPath = fileparts(mfilename('fullpath'));                            % folder containing this file
%     oldDir = pwd;                                                          % save current working directory
%     cd(gitPath)
%     if exist(fullfile(gitPath,'.git'), 'dir')                              % only pull if this is a git repo
%         system('git pull');
%     end
%     cd(oldDir)

    %---------------------------%
    %          CHECKS           %
    %---------------------------%
    [status1, cmdout1] = system('git --version');                          % Git installation
    status2 = ~exist('.git', 'dir');                                       % Repository
    [status3, cmdout3] = system('git config user.email');                  % Git Configuration

    if status1 ~= 0 || status2 ~= 0 || status3 ~= 0
        if status1 ~= 0
            error('Git is not installed or not in PATH: %s', cmdout1);
        elseif status2 ~= 0
            error('No .git directory found. Please get into a local Git repository folder.');
        elseif status3 ~= 0
            error('Git user.email is not configured: %s', cmdout3);
        else
            disp('All Git checks passed.')
        end
    end
    
    %---------------------------%
    %  CHECK FOR REMOTE CHANGES %
    %---------------------------%
    [status, output] = system('git fetch');                                % fetch latest remote commits
    if status ~= 0
        warning('Failed to fetch remote repository: %s', output);
    else                                                                   % check if local branch is behind remote
        [~, behindInfo] = system('git status -uno');                       % -uno = ignore untracked files
        if contains(behindInfo, 'Your branch is behind')
            choice = questdlg('Remote repository has new commits. Pull changes?', ...
                'Pull from remote', 'Yes', 'No', 'Yes');
            switch choice
                case 'Yes'
                    [pullStatus, pullOutput] = system('git pull');
                    if pullStatus == 0
                        disp('Pulled latest changes successfully.');
                    else
                        warning('Pull failed: %s', pullOutput);
                    end
                case 'No'
                    disp('Skipped pulling remote changes.');
            end
        else
            disp('Local repository is up-to-date with remote.');
        end
    end
    
    %---------------------------%
    %  CHECK FOR GITIGNORE FILE %
    %---------------------------%
    if ~exist('.gitignore', 'file')
        % Case 1: No .gitignore
        createIgnore = input('No .gitignore detected. Do you want to create one? [Y]es/[N]o: ', 's');
        if strcmpi(createIgnore, 'Y')
            disp('Enter files/folders to ignore, separated by commas.');
            disp('Examples:  *.pdf, /data/, secrets.txt');
            ignoreFiles = input('> ', 's');
            
            ignoreList = strtrim(strsplit(ignoreFiles, ',')); % split + trim
            
            fid = fopen('.gitignore', 'w');
            if fid ~= -1
                for k = 1:numel(ignoreList)
                    fprintf(fid, '%s\n', ignoreList{k});
                end
                fclose(fid);
                disp('.gitignore created.');
                system('git add .gitignore'); % stage it immediately
            else
                warning('Could not create .gitignore file.');
            end
        end
%     else
%         % Case 2: Existing .gitignore
%         updateIgnore = input('.gitignore detected. Do you want to add entries? [Y]es/[N]o: ', 's');
%         if strcmpi(updateIgnore, 'Y')
%             disp('Enter additional files/folders to ignore, separated by commas.');
%             ignoreFiles = input('> ', 's');
%             
%             ignoreList = strtrim(strsplit(ignoreFiles, ',')); % split + trim
%             
%             fid = fopen('.gitignore', 'a'); % append mode
%             if fid ~= -1
%                 for k = 1:numel(ignoreList)
%                     fprintf(fid, '%s\n', ignoreList{k});
%                 end
%                 fclose(fid);
%                 disp('Entries added to .gitignore.');
%                 system('git add .gitignore'); % stage updated ignore file
%             else
%                 warning('Could not update .gitignore file.');
%             end
%         end
    end
    
    %---------------------------%
    %      COMMIT & ADD         %
    %---------------------------%
    system('git add .');                                                   % stage all changes
    command = ['git commit -m "' message '"'];
    system(command);                                                       % commit with message
    
    %---------------------------%
    %   BRANCH SELECTION        %
    %---------------------------%
    [~, branchOutput] = system('git branch');
    branches = textscan(branchOutput, '%s', 'Delimiter', '\n');
    branches = branches{1};                                                % List all available branches

    disp(' ');
    disp('Available branches (* indicates current branch):');
    disp('0: Create a new branch');
    for i = 1:numel(branches)
        disp([num2str(i), ': ', branches{i}]);
    end
    disp([num2str(i+1), ': Exit']);

    branchOption = input('Which branch would you like to push changes to: ', 's');  % Ask the user which branch to make changes to
    

    if branchOption == '0'    
        newBranchName = input('Enter the name of the new branch: ', 's');  % Prompt the user for the new branch name
        if ~isempty(newBranchName)
            system(['git checkout -b ', newBranchName]);                   % Create and switch to the new branch
            system(['git push -u origin ', newBranchName]);                % Push changes to the new branch on the remote repository
            disp(['Changes pushed to new branch ', newBranchName]);
        else
            disp('Invalid branch name.');
        end
    elseif branchOption == num2str(i+1)                                    % User decided to exit 
        disp('No changes were pushed.');
    else                                                                   % Convert branchOption to a number and Validate the input
        branchIndex = str2double(branchOption);
        if isscalar(branchIndex) && branchIndex >= 1 && branchIndex ...
                <= numel(branches)
            branchName = branches{branchIndex};
            if startsWith(branchName, '*')                                 % Remove the asterisk (*) from the branch name if it's there
                branchName = branchName(2:end);
            end
            
            system(['git checkout ', branchName]);                         % Switch to the selected branch
                   
            
            [status, output] = system(['git push -u origin ', branchName]);% Push changes to the selected branch on the remote repository
            
            if status ~= 0
                disp(output);                                               %Changes were not successfully
            else
                disp(['Changes pushed to branch ', branchName]);           %Changes were successfully pushed
            end
        else
            disp('Invalid branch index.');
        end
    end

