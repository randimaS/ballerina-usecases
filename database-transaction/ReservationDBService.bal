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

        ReservationDBService:Reservation reservation;

        var payload = req.getJsonPayload();

        match payload {
            json jsonPayload => {

                reservation.hotel =   check <string>jsonPayload.hotelName;
                reservation.customerID = check <string>jsonPayload.customerId;
                reservation.customerName = check <string>jsonPayload.customerName;
                reservation.customerAddress = check <string>jsonPayload.customerAddr;
                reservation.startDate = check <string>jsonPayload.checkIn;
                reservation.endDate =  check <string>jsonPayload.checkOut;
                reservation.package = check <string>jsonPayload.package;
                reservation.fullAmount = check <float>jsonPayload.fullAmount;
                reservation.advanceAmount =  check <float>jsonPayload.advanceAmount;
                
                int dbResponseInt  = ReservationDBService:InsertOperation(reservation);

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