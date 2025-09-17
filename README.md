% GitCommit Toolbox

Commit and push changes to GitHub from MATLAB with one line. This toolbox
can be found in MATLAB's Add-Ons.

Usage:

  GitCommit('Your commit message')

This will:
1. Check Git and the configuration
2. Check if there are any remote changes
3. Check if a .gitignore needs to be created
4. Stage and commit all changes with single message
5. Push all changes to desired branch on the remote repository

Installation:
This function has already been packaged on MATLAB's Add-ons section
1. Home -> Environment -> Add-Ons
2. Select "Get Add-Ons" and search "gitcommit"
3. Add the toolbox

Once installed, the function can be called in the Command Window. Make sure you 
are in the local working folder that is associated with the remote repository. 

Requirements:
-Git installed and available in your system PATH
-Current folder must be a valid Git repository
-Git user configuration (name/email) set up

If these requirements are not fulfilled, see GitMatlab for easy installation of requirements. 
