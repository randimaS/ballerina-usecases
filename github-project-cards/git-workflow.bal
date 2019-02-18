import ballerina/config;
import ballerina/http;
import ballerina/io;
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
    github4:Repository|error result = githubClient->getRepository("wso2-ballerina/module-github");
    if (result is github4:Repository) {
        io:println("Repository wso2-ballerina/module-github: ", result);
    } else {
        io:println("Error occurred on getRepository(): ", result);
    }
}