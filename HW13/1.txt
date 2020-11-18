create table empl(
id varchar(50),
dadd datetime,
[name] varchar(150),
sex varchar(1),
birthday date,
dstatr date,
dend date,
fw varchar(1)
)

create table empl_param(
id varchar(50),
dadd datetime,
empl_id varchar(50),
[type] varchar(100),
[value] varchar(50),
a varchar(1),
dend datetime
)


create table department(
id varchar(50),
[name] varchar(100),
a varchar(1)
)
 
create table position(
id varchar(50),
[name] varchar(100),
a varchar(1)
)

create table equipment(
id varchar(50),
dadd datetime,
[type] varchar(100),
sn varchar(100),
account varchar(100),
[name] varchar(100),
[model] varchar(100),
collor varchar(100),
a varchar(1),
dend datetime
)

create table event_dc(
id varchar(50),
dadd datetime,
[name] varchar(100),
[desc] varchar(500)
)

create table [event](
id varchar(50),
dadd datetime,
event_id varchar(50),
empl_id varchar(50),
dstart date,
dend date
)

create table vacation(
id varchar(50),
dadd datetime,
empl_id varchar(50),
vacstart date,
vacend date,
a varchar(1)
)


create table wifi(
id varchar(50),
dadd datetime,
[name] varchar(100),
pass varchar(100),
a varchar(1)
)


create table workmode(
id varchar(50),
dadd datetime,
empl_id varchar(50),
monday varchar(50),
tuesday varchar(50),
wednesday varchar(50),
thursday varchar(50),
friday varchar(50),
saturday varchar(50),
sunday varchar(50),
dinner varchar(50),
a varchar(1)
)

CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[empl] (id)   
GO

CREATE NONCLUSTERED INDEX nc_name
ON empl ([name])   
GO

CREATE NONCLUSTERED INDEX nc_bt
ON empl (birthday)   
GO

CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[empl_param] (id)   
GO

CREATE NONCLUSTERED INDEX nc_a
ON [dbo].[empl_param] (a)   
GO

CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[department] (id)   
GO

CREATE NONCLUSTERED INDEX nc_name
ON [dbo].[department] ([name])   
GO

CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[position] (id)   
GO

CREATE NONCLUSTERED INDEX nc_name
ON [dbo].[position] ([name])   
GO


CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[wifi] (id)   
GO

CREATE NONCLUSTERED INDEX nc_name
ON [dbo].[wifi] ([name])   
GO

CREATE NONCLUSTERED INDEX nc_pass
ON [dbo].[wifi] (pass)   
GO

CREATE NONCLUSTERED INDEX nc_a
ON [dbo].[wifi] (a)   
GO

CREATE NONCLUSTERED INDEX nc_id
ON [dbo].[equipment] (id)   
GO

CREATE NONCLUSTERED INDEX nc_ac
ON [dbo].[equipment] (account)   
GO

CREATE NONCLUSTERED INDEX nc_a
ON [dbo].[equipment] (a)   
GO

CREATE NONCLUSTERED INDEX nc_eid
ON [dbo].[workmode] (empl_id)   
GO

CREATE NONCLUSTERED INDEX nc_a
ON [dbo].[workmode] (a)   
GO

