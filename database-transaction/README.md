# API with Database Transactions 

## Steps to setup

1. Run the DBScripts/ReservationDB.sql script to setupthe Reservation Database 
2. Update the MySQL Database configurations in the ballerina.conf file
3. Run the ReservationDBService API with following command 
```
ballerina run ReservationDBService.bal 

```
3. Invoke the API with following URL and payload

```
http://localhost:9090/reservationcrud/add

```
```json
{
	"hotelName": "Hotel1",
	"customerId": "custID1",
	"customerName": "testCust1",
	"customerAddr": "testCus1 Addr",
	"checkIn": "2018-10-12",
	"checkOut": "2018-10-14",
	"package": "standard",
	"fullAmount": 20000.00,
	"advanceAmount": 12000.00
}
```
