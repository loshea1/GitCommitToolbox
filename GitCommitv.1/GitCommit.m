% This script commits and pushes all changes to the desired branch in a GitHub repository.
function GitCommit(message)
% CHECKS
[status1, cmdout1] = system('git --version');         % Check if Git is installed
status2 = ~exist('.git', 'dir');                      % Check if .git directory exists to confirm it's a Git repository
[status3, cmdout3] = system('git config user.email'); % Get user email associated with Git to confirm configuration

if status1 ~= 0 || status2 ~= 0 || status3 ~= 0
    if status1 ~= 0
        disp(cmdout1);
    elseif status2 ~= 0
        disp('.git directory does not exist.');
    elseif status3 ~= 0
        disp(cmdout3);
    end
end
%=========================================================================%
% If all checks pass:
system('git pull') %pull any recent changes from online
system('git add .'); % Add all files to the staging area for commit

% Construct the Git commit command with the provided message
command = ['git commit -m "' message '"'];
system(command); % Execute the commit command

% List all available branches
[~, branchOutput] = system('git branch');
branches = textscan(branchOutput, '%s', 'Delimiter', '\n');
branches = branches{1};

% Display branches with associated index numbers
disp(' ');
disp('Available branches (* indicates current branch):');
disp('0: Create a new branch');
for i = 1:numel(branches)
    disp([num2str(i), ': ', branches{i}]);
end
disp([num2str(i+1), ': Exit']);

% Ask the user which branch to make changes to
branchOption = input('Which branch would you like to push changes to: ', 's');

if branchOption == '0'    %Create a new branch
    % Prompt the user for the new branch name
    newBranchName = input('Enter the name of the new branch: ', 's');
    if ~isempty(newBranchName)
        % Create and switch to the new branch
        system(['git checkout -b ', newBranchName]);
        % Push changes to the new branch on the remote repository
        system(['git push -u origin ', newBranchName]);
        disp(['Changes pushed to new branch ', newBranchName]);
    else
        disp('Invalid branch name.');
    end
elseif branchOption == num2str(i+1)
    disp('No changes were pushed.');
else
    % Convert branchOption to a number and Validate the input
    branchIndex = str2double(branchOption);
    if isscalar(branchIndex) && branchIndex >= 1 && branchIndex <= numel(branches)
        branchName = branches{branchIndex};
        % Remove the asterisk (*) from the branch name if it's there
        if startsWith(branchName, '*')
            branchName = branchName(2:end);
        end
        % Switch to the selected branch
        system(['git checkout ', branchName]);
        % Push changes to the selected branch on the remote repository
        system(['git push -u origin ', branchName]);
        disp(['Changes pushed to branch ', branchName]);
    else
        disp('Invalid branch index.');
    end
end

