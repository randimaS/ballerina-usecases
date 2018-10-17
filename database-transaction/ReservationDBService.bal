import ReservationDBService;
import ballerina/http;
import ballerina/log;
import ballerina/io;

@http:ServiceConfig { basePath: "/reservationcrud" }
service<http:Service> reservationDB bind { port: 9090 } {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/add"
    }
    addReservation(endpoint caller, http:Request req) {

        http:Response res = new;
        json insertStatusJson = {};

        var payload = req.getJsonPayload();

        match payload {
            json jsonPayload => {

                string hotelName =   ReservationDBService:Sanitize(check <string>jsonPayload.hotelName);
                string customerId = check <string>jsonPayload.customerId;
                string customerName = check <string>jsonPayload.customerName;
                string customerAddr = check <string>jsonPayload.customerAddr;
                string checkIn = check <string>jsonPayload.checkIn;
                string checkOut =  check <string>jsonPayload.checkOut;
                string package = check <string>jsonPayload.package;
                float fullAmount = check <float>jsonPayload.fullAmount;
                float advanceAmount =  check <float>jsonPayload.advanceAmount;

                int dbResponseInt  = ReservationDBService:InsertOperation(hotelName,customerId,customerName,customerAddr,checkIn,checkOut,package,fullAmount,advanceAmount);

                if(dbResponseInt == 1){
                    res.statusCode = 200;
                    insertStatusJson ={"status":"Reservation request is sent successfully"};
                }
                else{
                    res.statusCode = 500;
                    insertStatusJson ={"status":"Reservation request cannot be sent"};
                }

                res.setPayload(insertStatusJson);
            }
            error err => {
                res.statusCode = 500;
                res.setPayload(untaint err.message);
            }
        }

        caller->respond(res) but { error e => log:printError("Error sending response", err = e) };
    }
}