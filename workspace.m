import load_BA900_csv.*
BA900 = load_BA900_csv("./Data/");
data = BA900.data;

% Data Cleaning
data = fillmissing(data,'constant',0,'DataVariables',{'Deposits','Loans'});
data.Loan_Deposit_Ratio = data.Loan_Deposit_Ratio

writetable(data,"./Data/Clean.csv");

%% Parameter recieved from the UI
 start_date =datetime('2018-01-01');
 end_date =datetime('2018-11-01');
 %% Filter Data based on dates
 data = filter_databydate(start_date, end_date); 
 
 %% Market Sharer: Deposits
total_deposits_perBank = varfun(@sum,data(:,{'Bank_Name', 'Deposits'}),'GroupingVariable','Bank_Name');
total_deposits_perBank.Market_Share = total_deposits_perBank.sum_Deposits*100/sum(data.Deposits)
total_deposits_perBank = sortrows(total_deposits_perBank, 'Market_Share', 'ascend');

figure('Name','Market Share: Deposits');
barh(total_deposits_perBank.Market_Share);
set(gca,'YTickLabel',total_deposits_perBank.Bank_Name)
grid on

%% Market Share: Loans
 
total_loans_perBank = varfun(@sum,data(:,{'Bank_Name', 'Loans'}),'GroupingVariable','Bank_Name');
total_loans_perBank.Market_Share = total_loans_perBank.sum_Loans*100/sum(data.Loans);
total_loans_perBank = sortrows(total_loans_perBank, 'Market_Share', 'ascend');

figure('Name','Market Share: Loans');
barh(total_loans_perBank.Market_Share);
set(gca,'YTickLabel',total_loans_perBank.Bank_Name);
grid on 
 
 %% LTD Ratio: Trend 
LDR_per_Month = data(:,{'Date', 'Bank_Name', 'Loan_Deposit_Ratio'});
bank_names = {'Capitec','Investec','ABSA','FNB','Standard Bank','Nedbank'};
colors = jet(length(bank_names));

figure('Name','Loan-to-Deposit Ratio: Trend');
 
hold on
for k=1:length(bank_names)
  filter = ismember(LDR_per_Month.Bank_Name,{bank_names{k}});
  ldr_bank_data = LDR_per_Month(filter,{'Date','Loan_Deposit_Ratio'});
  plot(ldr_bank_data.Date, ldr_bank_data.Loan_Deposit_Ratio,'marker','.','color',colors(k,:),'DisplayName',bank_names{k});
end
hold off
legend show




 
    

