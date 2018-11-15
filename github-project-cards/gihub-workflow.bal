import ballerina/io;
import ballerina/http;
import ballerina/config;
import ballerina/time;
import wso2/github4;

endpoint github4:Client githubEP {
    clientConfig: {
        auth:{
            scheme:http:OAUTH2,
            accessToken:config:getAsString("GITHUB_TOKEN")
        }
    }
};


public function main(string... args) {

    time:Time CurrentTime = time:currentTime();

    github4:Repository repository;
    github4:Project project;
    github4:Column[] cloumnArray;

    var repo = githubEP->getRepository("exp-org/ballerina-ground");

    match repo{
        github4:Repository repositoryResponse=>{
            repository = repositoryResponse;
        }
        error err => {
            io:println("It is not a GitHub Repo");
        }
    }

    var prj = githubEP->getRepositoryProject(repository,1);

    match prj{
        github4:Project prjResponse=>{
            project = prjResponse;
        }
        error err => {
            io:println("It is not a GitHub Project");
        }
    }

    var columns = githubEP->getProjectColumnList(project, 10);

    match columns{
        github4:ColumnList columnList=>{
            cloumnArray = columnList.getAllColumns();
        }
        error err => {
            io:println("It is not a GitHub Column List");
        }
    }

    foreach column in cloumnArray {
        github4:CardList cardList = column.getCardList();
        github4:Card[] cardArray = cardList.getAllCards();

        foreach card in cardArray{

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

    ///time:Time t1 = time:parse("09:40:00", "HH:mm:ss");
    //time:Time t2 = time:parse("09:55:00", "HH:mm:ss");
    //int timeDiffInMillSeconds = t2.time - t1.time;
    //int timeDiffInMinutes = timeDiffInMillSeconds/60000;

}
