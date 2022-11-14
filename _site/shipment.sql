------------------------------------------------------------------
--  TABLE shipment
------------------------------------------------------------------

CREATE TABLE shipment
(
   `ShipmentID`          int(10),
   `ExternalAccountID`   varchar(40),
   `Description`         varchar(255),
   `Priority`            varchar(20),
   `Status`              varchar(20)
);


