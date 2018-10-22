import ballerina/io;
import ballerina/mysql;
import ballerina/jdbc;
import ballerina/log;
import ballerina/config;

endpoint jdbc:Client reservationDB {
    url: config:getAsString("JDBC_URL"),
    username: config:getAsString("MYSQL_USER"),
    password: config:getAsString("MYSQL_PASSWORD"),
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
};

public function InsertOperation(Reservation reservation) returns (int){

    string sanatizedTableName = Sanitize(reservation.hotel);
    string sqlQuery = "INSERT INTO "+ sanatizedTableName + "(CustomerID,CustomerName,CustomerAddress,StartDate,EndDate,Package,FullAmount,AdvanceAmount) VALUES(?,?,?,?,?,?,?,?);";

    int insertStatus = 0;

    transaction with retries = 4, oncommit = onCommitFunction,
                     onabort = onAbortFunction {
        var resultStatus = reservationDB->update(sqlQuery,reservation.customerID,reservation.customerName,reservation.customerAddress,reservation.startDate,reservation.endDate,reservation.package,reservation.fullAmount,reservation.advanceAmount);

        match resultStatus {
            int resultInt => {
                log:printInfo("Insert Sucessful for customerID : "+reservation.customerID);
                insertStatus = resultInt;
            }
            error e => {
                log:printError("Insert failed for customerID : "+reservation.customerID + " Error : "+e.message);
                insertStatus =  0;
                abort;
            }
        }
    } onretry {
        log:printInfo("Retrying transaction");
    }

    return insertStatus;
}

public function Sanitize(string input) returns @untainted string {
    string regEx = "[^a-zA-Z-0-9]+";
    return input.replace(regEx, "");
}

public function onCommitFunction(string transactionId) {
    log:printInfo("Transaction: " + transactionId + " committed");
}

public function onAbortFunction(string transactionId) {
    log:printError("Transaction: " + transactionId + " aborted");
}