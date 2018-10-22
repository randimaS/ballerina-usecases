import ballerina/test;
import ballerina/http;

endpoint http:Client reservationServiceEP {
    url:"http://localhost:9095/reservationcrud"
};

@test:Config
function testReservationDataServiceSuccess() {

    http:Request request = new;
    json reservationRequest = {
            "hotelName": "Hotel1",
            "customerId": "11111111v",
            "customerName" : "testCust2",
            "customerAddr" : "testCus2 Addr",
            "checkIn" : "2018-10-12",
            "checkOut" : "2018-10-14",
            "package" : "standard",
            "fullAmount" : 20000.00,
            "advanceAmount" :12000.00
    };

    request.setJsonPayload(reservationRequest);

    var response = reservationServiceEP -> execute("POST", "/add", request);

    match response {
        http:Response res => {

            int responseStatus = res.statusCode;
            int expectedStatus = 200;
            test:assertEquals(responseStatus, expectedStatus, msg = "Reservation Data Service status code is not 200");

            json responsePayload = check res.getJsonPayload();
            json expectedPayload = {"status":"Reservation request is sent successfully"};
            test:assertEquals(responsePayload, expectedPayload, msg = "Reservation Data Service response mismatch");

        }
        error err => {
            test:assertFail(msg = "Error in endpoint call" + err.message);
        }
    }
}


@test:Config
function testReservationDataServiceInvalidData() {

    http:Request request = new;
    json reservationRequest = {
            "hotelName": "",
            "customerId": "11111111v",
            "customerName" : "testCust2",
            "customerAddr" : "testCus2 Addr",
            "checkIn" : "2018-10-12",
            "checkOut" : "2018-10-14",
            "package" : "standard",
            "fullAmount" : 20000.00,
            "advanceAmount" :12000.00
    };

    request.setJsonPayload(reservationRequest);

    var response = reservationServiceEP -> execute("POST", "/add", request);

    match response {
        http:Response res => {

            int responseStatus = res.statusCode;
            int expectedStatus = 500;
            test:assertEquals(responseStatus, expectedStatus, msg = "Reservation Data Service code is not 500");

            json responsePayload = check res.getJsonPayload();
            json expectedPayload = {"status":"Reservation request cannot be sent"};
            test:assertEquals(responsePayload, expectedPayload, msg = "Reservation Data Service response mismatch");

        }
        error err => {
            test:assertFail(msg = "Error in endpoint call" + err.message);
        }
    }
}

@test:Config
function testReservationDataServiceInvalidType() {

    http:Request request = new;
    json reservationRequest = {
            "hotelName": "Hotel1",
            "customerId": "11111111v",
            "customerName" : "testCust2",
            "customerAddr" : "testCus2 Addr",
            "checkIn" : "2018-10-12",
            "checkOut" : "2018-10-14",
            "package" : "standard",
            "fullAmount" : 20000.00,
            "advanceAmount" :"12000.00"
    };

    request.setJsonPayload(reservationRequest);

    var response = reservationServiceEP -> execute("POST", "/add", request);

    match response {
        http:Response res => {

            int responseStatus = res.statusCode;
            int expectedStatus = 500;
            test:assertEquals(responseStatus, expectedStatus, msg = "Reservation Data Service code is not 500");

            json responsePayload = check res.getTextPayload();
            string expectedPayload = "call failed";
            test:assertEquals(responsePayload, expectedPayload, msg = "Reservation Data Service response mismatch");

        }
        error err => {
            test:assertFail(msg = "Error in endpoint call" + err.message);
        }
    }
}
