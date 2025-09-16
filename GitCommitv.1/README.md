# GitCommit
This function assumes that your code is already associated with a git repository.  
To add this function to a project, perform the following steps:
1. Navigate to a folder where you want to save the function (I saved it to my C drive. C:\Users\Username\MATLAB). In the Command Window write this line of code:  
    	**!git clone https://github.com/PattonRoboticsLab/GitCommit.git**
2. In your main code, add the following lines:  
    	**Path1 = 'path/to/current/folder';  
			Path2 = 'path/to/GitCommit/function';  
			addpath(Path1)  
			cd(Path2)   
			!git pull   
			cd(Path1)**  
   These lines of codes tells Matlab where to look for the file in Path1, navigates to the GitCommit folder (Path2), pulls any changes made to the function, and then navigates back to the main code folder (Path1).  
     Make sure to change the paths to the correct locations. 
4. You can call the function from the Command Window or add it to the end of your code to automatically commit the changes:	
   	 **GitCommit('message')**  
  	 Change the message to whatever you want it to be.

This code checks to make sure git is installed, that there is an active local directory, and that you are connected to git with your email.

If all of these check out, then it will pull any recent changes, add all files in the staging area, commit the changes, and push to the desired branch. 
