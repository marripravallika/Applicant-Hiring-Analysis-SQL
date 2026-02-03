create database Applicant_Analysis;
use Applicant_Analysis;

create table Applicants (
    applicant_id int primary key,
    name varchar(50),
    college varchar(50),
    degree varchar(20),
    signup_date date
);

create table Applications (
    application_id int primary key,
    applicant_id int,
    stage varchar(20),
    stage_date date,
    foreign key (applicant_id) references applicants(applicant_id)
);
