# vpc-sc-test
vpc service controls tests

# vpc-sc-test - PJ's VPC SC test  playground

Multiple Ways to Autheticate 
1. Using gcloud auth application default login on VS Code
2. Using Cloud Shell 
3. Using a service a/c - create an account, create key, download key, put in the same folder as ./main.tf. Export an environment variable or you can define a Terraform variable. 
    export GOOGLE_CLOUD_KEYFILE_JSON="$(pwd)/tf-samplekeyFile.json"
    cat `echo ${GOOGLE_CLOUD_KEYFILE_JSON}`
4. If credentials variable is configured in main.tf OR environment variable is set up at the prompt as in steps 8.3.1 - it would override pjoura@

# Steps to Check-In new code , git commands
NOTE: Here vpcsc-fr1 is the feature branch name
0.  Ensure your feature branch is checked out git checkout <brancg-name> 
1.  Make the edits you would like
2.  git status
3.  git add . 
4.  git status 
5.  git commit -m "comment a message" -- This will commit the code to your branch local copy only
6.  git push origin vpcsc-fr1 -- This will push the code to feature branch remote server
7.  git checkout main -- This is required to merge the feature branch to main
8.  git merge vpcsc-fr1 -- This will merge (link) feature branch to main branch
9.  < Now your Feature Branch and Main branch are out of sync on remote server>
10. git push origin main -- This will sync the code between the 2 branches on the remote server