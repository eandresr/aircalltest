#DYAGRAM
![Alt text](test_dyagram.png?raw=true "Title")
# README
The code is structured with the needed adaption for CI/CD, with separate unic folder for the code and other folder for every environment you want.
This way we have always the same infrastructure code for every environment, the only things that will change are the variables values and backend values.
This is the way I work, there are many other ways but this is the best way I used focused on a Operation of the Terraform (more fixed and structured, 
reducing copy/paste human problems and reducing time debugging/copying between environments when a iteration with the code is made)


IMPORTANT:
-----------
As we mantain only one folder, we MUST delete the .terraform every time we init the template, for secure. If any problem occurs we could overwrite the tfstate file.
Regarding the previous, it is worth recommended to enable versioning on the bucket, to prevent unsolveable problems.


DEPLOYMENT ORDER
----------------------
This is a not complex architecture, but with several components, and those components have interdependancies between them, so the order of deployment it is critical 
for time saving waiting dependancies errors. The order is the following:


1 - S3/images
2 - S3/build
3 - S3/front
4 - Cognito User Pool
5 - WAF
6 - CodeCommit
7 - Lambda
8 - APIGateway --> API
9 - ApiGateway --> Components
10 - ApiGateway --> Components (auth)
11 - Cognito Client
12 - CloudFront
13 - CodeBuild
14 - CodeDeploy
15 - CodePipeline




INIT
------------------
Before anything it is necceesary to do a init, but with this approach we need to init specifying the backend variables, in a relatiive path from the code resource folder:

    usr@localhost:/opt/repos/aircalltest/code/cicd/codecommit$ terraform init -backend-config=../../../env/dev/cicd/codecommit/backend.tfvars

as we can see aboce our current path is /opt/repos/aircalltest/code/cicd/codecommit, regarding the project: <code/cicd/codecommit>, so the relative path of the variables should have <../../../env>

PLAN/APPLY
------------------
We have the same way like INIT (above), so we just have to go to the desired component into the code folder subtree and then apply with the following:

    terraform plan -var-file=../../../env/dev/cicd/codecommit/vars.tfvars
    terraform apply -var-file=../../../env/dev/cicd/codecommit/vars.tfvars



TEST/RESULTS
------------------
To check, the most important thing is the CloudFront domain name (in this case we are not using owned Domian because is for this test). Then call the following ways:
- Front: https://<cloudfront-url>/
- API With Auth: https://<cloudfront-url>/auth/image
- API Without Auth: https://<cloudfront-url>/image
