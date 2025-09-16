# GitCommit Version 2

%% GitCommit Toolbox

% Commit and push changes to GitHub from MATLAB with one line.

%

% Usage:

%   GitCommit("Your commit message")

%

% Example:

%   GitCommit("Fixed bug in data processing script")

%

% This will:

%   1. Update GitCommit.m from GitHub (if cloned from repo).

%   2. Pull the latest changes from the remote repository.

%   3. Stage all modified files.

%   4. Commit with the provided message.

%   5. Ask you which branch to push to (or let you create a new one).

%

%% Requirements

% \* Git installed and available in your system PATH.

% \* Current folder must be a valid Git repository.

% \* Git user configuration (name/email) set up.

%

%% Installation

% 1. Clone the repo or download the GitCommit.m file.

% 2. Package into a MATLAB toolbox (.mltbx):

%    - MATLAB Home tab → Add-Ons → Package Toolbox.

%    - Select the GitCommit folder and follow the wizard.

% 3. Install the toolbox by double-clicking the .mltbx file.

%

%% Notes

% \* The function auto-updates itself from GitHub if installed via git clone.

% \* You can use it in any MATLAB project linked to a Git repository.

