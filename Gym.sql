-- Creating new table gym
create table Gym (
	InstNr int,
    InstNavn varchar(255),
    OptNr int,
    OptNavn varchar(255),
    I_alt int,
    Uoplyst int,
    STX INT,
    HF INT,
    HHX INT,
    HTX INT,
    Andet_udland int,
    EUD int,
    IB INT,
    EUX INT,
    ANDET INT);

-- Enable local file import  
SET GLOBAL local_infile=1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- Loading gym from csv
LOAD DATA local INFILE 
	'C:/Users/Viet Nguyen/Documents/ibm_data_science/SQL_for_data_science/SQL_Portfolio project/Videre_gaaende_uddannelser/python/gy.csv'
INTO TABLE 
	gym
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Test Showing Data Frame
select *
from gym;

-- Grouping matching optnavn and taking the sum of the students and selecting the max optnr
create view gym_fordeling as
select 
	instnr, 
	InstNavn,
	Max(optnr) as OptNr,
	optnavn, 
    sum(i_alt) as total,
    sum(Stx) as STX,
    sum(HF) AS HF,
    SUM(HHX) AS HHX,
    SUM(HTX) AS HTX,
    SUM(ANDET_UDLAND) AS udland,
    SUM(EUD) AS EUD,
    SUM(IB) AS IB,
    SUM(EUX) AS EUX,
    SUM(ANDET) + sum(uoplyst) AS ANDET
from 
	gym			
group by 
	InstNr, 
    InstNavn, 
    OptNavn
order by InstNr;

-- Testing gym_fordeling
select * from gym_fordeling;

-- Creating acceptence-reasoning percentage distibution 
create view gym_procentfordeling as
select
	instnr,
    instnavn,
    optnr,
    optnavn,
    Total,
    (stx/total)*100 As STX,
    (hf/total)*100 AS HF,
    (hhx/total)*100 as HHX,
    (htx/total)*100 AS HTX,
    (udland/total)*100 AS UDLAND,
    (eud/total)*100 AS EUD,
    (ib/total)*100 AS IB,
    (eux/total)*100 AS EUX,
    (andet/total)*100 AS ANDET
from gym_fordeling
order by instnr, total desc;

-- Testing gym_procentfordeling
select * from gym_procentfordeling;

-- Grouping acceptence reasoning for the individual universities and creating new view
create view gym_unifordeling as
Select
	instnr,
    instnavn,
	sum(total) as total,
    sum(Stx) as STX,
    sum(HF) AS HF,
    SUM(HHX) AS HHX,
    SUM(HTX) AS HTX,
    SUM(udland) AS UDLAND,
    SUM(EUD) AS EUD,
    SUM(IB) AS IB,
    SUM(EUX) AS EUX,
    SUM(ANDET) AS ANDET
from 
	gym_fordeling
group by
	instnr, instnavn
order by 
	instnr;
    
-- Testing view 
select * from gym_unifordeling;

-- Creating new percentage acceptence reasoning for individual universities view
create view gym_uniprocentfordeling as
select
	instnr,
    instnavn,
    Total,
    (stx/total)*100 As STX,
    (hf/total)*100 AS HF,
    (hhx/total)*100 as HHX,
    (htx/total)*100 AS HTX,
    (udland/total)*100 AS UDLAND,
    (eud/total)*100 AS EUD,
    (ib/total)*100 AS IB,
    (eux/total)*100 AS EUX,
    (andet/total)*100 as Andet
from 
	gym_unifordeling
order by
	instnr;

-- Testing view
select * from gym_uniprocentfordeling;

