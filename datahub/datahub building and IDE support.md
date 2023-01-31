Fork and clone the repository if haven't done so already  

git clone https://github.com/{username}/datahub.git  
Change into the repository's root directory  

cd datahub  
Use gradle wrapper to build the project  

./gradlew build -x test  

IDE Support
The recommended IDE for DataHub development is IntelliJ IDEA. You can run the following command to generate or update the IntelliJ project file  

./gradlew idea -x test  
Open datahub.ipr in IntelliJ to start developing!