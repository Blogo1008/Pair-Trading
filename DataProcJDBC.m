function [ Quotes,LnQuotes,StdQuotes,CovMatx,CorrMatx,CovMatx4LnQuotes,CorrMatx4LnQuotes,CovMatx4StdQuotes,CorrMatx4StdQuotes] = DataProcJDBC( IndtyName,databasename,username,password,driver,databaseurl )
%DataProc Summary of this function goes here
%   Detailed explanation goes here
%   In 
%   IndtyName,databasename,username,password,driver,databaseurl
%       
%   Out 
%   Quotes,LnQuotes,StdQuotes,CovMatx,CorrMatx,CovMatx4LnQuotes,CorrMatx4LnQuotes,CovMatx4StdQuotes,CorrMatx4StdQuotes
%       
%%%%%%%%%



conn = database(databasename,username,password,driver,databaseurl);
if isconnection(conn)==1
    tic
    %QOT_D_BCK��Ϊ��Ȩ�����������ǰ��Ȩ��
    %��Ҫ��������ݣ�����ָ�����������룬��������Ҫ�����ֵ����
    %curs=exec(conn,'select IDX.PUB_DT,A.F0050 from (select * from QOT_D_BCK where SEC_CD=''600000'' and VAR_CL=''A'') A right join (select * from QOT_D_BCK where SEC_CD=''000001'' and VAR_CL=''Z'') IDX on A.PUB_DT=IDX.PUB_DT order by IDX.PUB_DT');
    %����Ҫ��������ݣ�Ŀǰʹ�õ�JRTZ_ANA���ݿ��Ѿ����룬ͣ���ռ۸������һ�����̼ۣ��ɽ���Ϊ0
    %curs=exec(conn,'select PUB_DT,F0050 from QOT_D_BCK where SEC_CD=''600000'' and VAR_CL=''A'' and PUB_DT>=''2010-1-1'' order by PUB_DT');

    %�ӵ�ǰĿ¼��ȡ�����bank.csv����cell��
    [bankname,bankticker]=textread(IndtyName,'%s%s','delimiter', ',');
    %��cell�еĴ���ȡ����
    banks=cell2mat(bankticker(2:end));

    %��ȡ��ָ֤����ȷ�����ݳ���
    startdate='2010-1-1';%��ʼ����
    sqlstr=['select PUB_DT,F0050 from QOT_D_BCK where SEC_CD=''','000001',''' and VAR_CL=''Z'' and PUB_DT>=''',startdate,''' order by PUB_DT'];
    curs=exec(conn,sqlstr);
    curs=fetch(curs);
    data=curs.Data;
    idx=cell2mat(data(:,2));

    n=0;
    for i=1:length(banks)
        sqlstr=['select PUB_DT,F0050 from QOT_D_BCK where SEC_CD=''',banks(i,:),''' and VAR_CL=''A'' and PUB_DT>=''',startdate,''' order by PUB_DT'];
        curs=exec(conn,sqlstr);
        curs=fetch(curs);
        data=curs.Data;
        p=cell2mat(data(:,2));
        %���ݲ���Ĺ�Ʊ����
        if length(p)~=length(idx)
            continue
        end
        n=n+1;
        price(:,n)=p;
    end
    toc
    close(curs);      %�ر��α���� 
    
    Quotes = price;
    LnQuotes = log(price);
    m = size(price,1);
    avg = mean(price);
    dev = std(price);
    StdQuotes = (price - avg(ones(m,1),:))./dev(ones(m,1),:);
    CovMatx = cov(price);
    CorrMatx = corrcoef(price);
    CovMatx4LnQuotes = cov(LnQuotes);
    CorrMatx4LnQuotes = corrcoef(LnQuotes);
    CovMatx4StdQuotes = cov(StdQuotes);
    CorrMatx4StdQuotes = corrcoef(StdQuotes);
     
    close(conn); 
end
     %�ر����ݿ����Ӷ��� 

