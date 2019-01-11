import ballerina/io;
import ballerina/http;
import ballerina/config;
import ballerina/time;
import wso2/github4;

github4:GitHubConfiguration gitHubConfig = {
     clientConfig: {
         auth: {
             scheme: http:OAUTH2,
             accessToken: config:getAsString("GITHUB_TOKEN")
         }
     }
 };

github4:Client githubClient = new(gitHubConfig);

public function main() {

    time:Time CurrentTime = time:currentTime();

    github4:Repository repository = {};
    github4:Project project = {};
    github4:Column[] cloumnArray = []; 

    github4:Repository|error gitRepoResult = githubClient->getRepository("exp-org/ballerina-ground");
    if (gitRepoResult is github4:Repository) {
        io:println("Repository exp-org/ballerina-ground: ", gitRepoResult);
        repository = gitRepoResult;
    } else {
        io:println("Error occurred on getRepository(): ", gitRepoResult);
    }

    github4:Project|error gitPrjresult = githubClient->getRepositoryProject(repository,1);
    if (gitPrjresult is github4:Project) {
        io:println("First Project in the repository : ", gitPrjresult);
        project = gitPrjresult;
    } else {
        io:println("Error occurred on getRepositoryProject(): ", gitPrjresult);
    }

    github4:ColumnList|error gitColresult = githubClient->getProjectColumnList(project,10);
    if (gitColresult is github4:ColumnList) {
        io:println("Columns in the Project : ", gitColresult.getAllColumns());
        cloumnArray = gitColresult.getAllColumns();
    } else {
        io:println("Error occurred on getProjectColumnList() : ", gitColresult);
    }

    foreach var column in cloumnArray {
        github4:CardList cardList = column.getCardList();
        github4:Card[] cardArray = cardList.nodes;

        foreach var card in cardArray{

            io:println("Printing the card details: ",card);

            string updatedDateString = card.updatedAt ?: "";
            time:Time updatedTime = time:parse(updatedDateString, "yyyy-MM-dd'T'HH:mm:ss'Z'");

            int timeDiffInMillSeconds = CurrentTime.time - updatedTime.time;
            int timeDiffInHours = timeDiffInMillSeconds/3600000;
            int timeDiffInDays = timeDiffInHours/24;

            if (timeDiffInDays>5){
                io:println("Need to send an email");
            }
            else{
                io:println("No need to send an email");
            }
        }
    }
}
