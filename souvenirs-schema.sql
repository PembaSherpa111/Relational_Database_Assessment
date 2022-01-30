use master;
go 
drop database if exists Souvenir;
go 
create database Souvenir;
go 
use Souvenir;
go 

create table Category(
    CategoryID int primary key identity(1,1),
    CategoryName varchar(25) not null
);

create table SouvenirOwner(
    SouvenirOwnerID int primary key identity(1,1),
    OwnerName varchar(25) not null
);

create table SouvenirLocation(
    SouvenirLocationID int primary key identity(1,1),
    City varchar(25) null,
    Region varchar(50) null,
    Country varchar(25) null,
    Longitude decimal(10,6) null,
    Latitude decimal(10,6) null
);

create table Souvenir(
    SouvenirID int primary key identity(1,1),
    SouvenirName varchar(100) not null,
    SouvenirDescription varchar(200) null,
    CategoryID int not null,
    SouvenirOwnerID int not null,
    SouvenirLocationID int null,
    Price decimal(10,2) null,
    SouvenirWeight decimal(8,2) null,
    DateObtained datetime2 not null,
    constraint fk_Souvenir_CategoryID
        foreign key (CategoryID)
        references Category(CategoryID),
    constraint fk_Souvenir_SouvenirOwnerID
        foreign key (SouvenirOwnerID)
        references SouvenirOwner(SouvenirOwnerID),
    constraint fk_Souvenir_SouvenirLocationID
        foreign key (SouvenirLocationID)
        references SouvenirLocation(SouvenirLocationID),
);