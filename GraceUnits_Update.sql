drop table entuser.INSTANTIATED_PROPERTY_BKP_DEMO;
CREATE TABLE entuser.INSTANTIATED_PROPERTY_BKP_DEMO tablespace SIDATA PARALLEL 5
AS
select /*+ parallel(5) */ LICENSE_NUMBER,CORE_PROPERTY_SETID, NUMERIC_PROPERTY_VALUE, PROPERTY_VALUE
from entuser.INSTANTIATED_PROPERTY where LICENSE_NUMBER in (
select LICENSE_NUMBER from entuser.ENTITLEMENT
where ENTITLEMENT_OFFER_CODE in ('518507','583723','568449','129813','896836','629727','255251','812350',
'365830','866374','355957','841214','585705','807950','038695','245344','835775','340736')
) and PROPERTY_TYPE_NAME = 'GRACE_UNITS' AND NUMERIC_PROPERTY_VALUE < 20;
-- 11.8 min
create index ind1 on entuser.INSTANTIATED_PROPERTY_BKP_DEMO (LICENSE_NUMBER, CORE_PROPERTY_SETID) parallel 7;
alter index ind1 parallel 1;
-- 7 sec
/*
select LICENSE_NUMBER,CORE_PROPERTY_SETID, NUMERIC_PROPERTY_VALUE, PROPERTY_VALUE from  entuser.INSTANTIATED_PROPERTY_BKP_DEMO  b 
where license_number=034772631270820 and PROPERTY_VALUE='4';
select LICENSE_NUMBER,CORE_PROPERTY_SETID, NUMERIC_PROPERTY_VALUE, PROPERTY_VALUE,B.Property_Name from  entuser.INSTANTIATED_PROPERTY  b 
where  CORE_PROPERTY_SETID=1111201803 and license_number='034772631270820' ;
*/
create or replace procedure entuser.QBDT_GRACEUNTITS_Update
as
CURSOR c1 is select /*+ parallel(b,8) */ * from  entuser.INSTANTIATED_PROPERTY_BKP_DEMO;
type l_cur is table of c1%rowtype ;
l_record l_cur;
l_error_count number :=0;
begin
   open  c1 ;
loop
   fetch  c1  bulk collect into l_record limit 10000;
   exit when  l_record.count=0;
   
   forall k in 1 ..l_record.count
   update entuser.INSTANTIATED_PROPERTY SET PROPERTY_VALUE='20', NUMERIC_PROPERTY_VALUE=20 where LICENSE_NUMBER=l_record(k).LICENSE_NUMBER and CORE_PROPERTY_SETID =l_record(k).CORE_PROPERTY_SETID AND PROPERTY_TYPE_NAME = 'GRACE_UNITS';
commit;
end loop;
end;
/
exec entuser.QBDT_GRACEUNTITS_Update;