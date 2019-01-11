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

    github4:Repository repository = {};
    github4:Project project = {};
    github4:Column[] cloumnArray = []; 
    github4:Card[] cardArray = []; 

    repository = getGithubRepository(githubClient,"exp-org/ballerina-ground");

    project = getGithubRepositoryProject(githubClient,repository,1);

    cloumnArray = getGithubProjectColumns (githubClient,project,10);

    cardArray = getOlderGitHubCards(cloumnArray,5);
}


public function getGithubRepository (github4:Client githubClientEP,string repositoryName) returns github4:Repository{

    github4:Repository repository ={};

    github4:Repository|error gitRepoResult = githubClientEP->getRepository(repositoryName);

    if (gitRepoResult is github4:Repository) {
        io:println("GitHub Repository : ", gitRepoResult);
        repository = gitRepoResult;
    } else {
        io:println("Error occurred on getting GitHub Repository : ", gitRepoResult);
    }

    return repository;
}

public function getGithubRepositoryProject (github4:Client githubClientEP,github4:Repository repository, int projectNumber) returns github4:Project{

    github4:Project project ={};

    github4:Project|error gitPrjresult = githubClientEP->getRepositoryProject(repository,projectNumber);

    if (gitPrjresult is github4:Project) {
        io:println("Github project ",projectNumber ," is in ",repository, " repository : ", gitPrjresult);
        project = gitPrjresult;
    } else {
        io:println("Error occurred on getting GitHub Project : ", gitPrjresult);
    }
    
    return project;
}

public function getGithubProjectColumns (github4:Client githubClientEP,github4:Project project, int columnCount) returns github4:Column[] {

    github4:Column[] prjCloumnArray = [];

    github4:ColumnList|error gitColresult = githubClientEP->getProjectColumnList(project,columnCount);

    if (gitColresult is github4:ColumnList) {
        io:println("Columns in the ",project," project : ", gitColresult.getAllColumns());
        prjCloumnArray = gitColresult.getAllColumns();
    } else {
        io:println("Error occurred on getting GitHub Project Columns : ", gitColresult);
    }

    return prjCloumnArray;
}

public function getOlderGitHubCards (github4:Column[] prjCloumnArray, int delayDaysCount) returns github4:Card[] {

    time:Time CurrentTime = time:currentTime();
    github4:Card[] olderCards = [];

    foreach var column in prjCloumnArray {

        github4:CardList cardList = column.getCardList();
        github4:Card[] cardArray = cardList.nodes;
        int i = 0;

        foreach var card in cardArray{

            io:println("Printing the card details: ",card);

            string updatedDateString = card.updatedAt ?: "";
            time:Time updatedTime = time:parse(updatedDateString, "yyyy-MM-dd'T'HH:mm:ss'Z'");

            int timeDiffInMillSeconds = CurrentTime.time - updatedTime.time;
            int timeDiffInHours = timeDiffInMillSeconds/3600000;
            int timeDiffInDays = timeDiffInHours/24;

            if (timeDiffInDays>delayDaysCount){
                io:println("Need to send an email");
                olderCards[i] = card;
                i = i+1;
            }
            else{
                io:println("No need to send an email");
            }
        }
    }

    return olderCards;
}