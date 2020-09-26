%%
classdef load_BA900_csv
%%
    properties    
       data;
    end
%%
    methods
%%
        function obj = load_BA900_csv(data_dir)
                        
            % For each folder 
            folder_contents = dir(data_dir);
            file_count = 0;
            data = {};
            for i=1:length(folder_contents)
                if ~strcmp( folder_contents(i).name, '.')  && ~strcmp( folder_contents(i).name, '..')
                    
                    % For each file in folder
                    bank_files = dir(data_dir+folder_contents(i).name+"/");
                    for j=1:length(bank_files)
                        file_count = file_count + 1;
                        if ~strcmp( bank_files(j).name, '.')  && ~strcmp( bank_files(j).name, '..') && contains(bank_files(j).name, ".csv") && ~contains(bank_files(j).name, "TOTAL") 
                            
                            % Read Data
                            date = obj.get_date(folder_contents(i).name);
                            [bank_code,bank_name] =obj.get_bank_code( bank_files(j).name);
                            deposit =obj.get_deposit(bank_files(j).folder + "/" +bank_files(j).name);
                            loan =obj.get_loan(bank_files(j).folder + "/" +bank_files(j).name);
                            
                            % Read Totals
                            deposit_total = obj.get_deposit_total(bank_files(j).folder + "/TOTAL.csv");
                            loan_total = obj.get_loan_total(bank_files(j).folder + "/TOTAL.csv");
                            
                             % Calculate Features
                            loan_deposit_ratio = loan/deposit;
                            market_share_deposits =deposit/deposit_total;
                            market_share_loans = loan/loan_total;
                            
                            % Construct data array for each row
                            row = {date bank_code bank_name deposit loan loan_deposit_ratio market_share_deposits market_share_loans};
                            data = cat(1, data,row);
                        end
                  
                    end
                end
            end
            
            % Create Data Table
            data=cell2table(data,'VariableNames',{'Date' 'Bank_Code' 'Bank_Name' 'Deposits' 'Loans' 'Loan_Deposit_Ratio' 'Market_Share_Deposits' 'Market_Share_Loans'});
            % assigning data as class property
            obj.data = data;
        end
   %%     
        function date = get_date(obj,folder_name)
            date = strtrim(string(folder_name));
            date = datetime(date);
          
         end
  %%      
        function deposit = get_deposit(obj,filepath)
            % Import Options
            opts = delimitedTextImportOptions("NumVariables", 10);

            % Specify range and delimiter
            opts.DataLines = [7, 7];
            opts.Delimiter = ",";

            % Specify column names and types
            opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "TOTAL7", "Var10"];
            opts.SelectedVariableNames = "TOTAL7";
            opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "double", "string"];
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 10], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 10], "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            deposit = readtable(filepath, opts);
            deposit=deposit{:,"TOTAL7"};
        end
%%    
        function loan = get_loan(obj,filepath)
            opts = delimitedTextImportOptions("NumVariables", 10);

            % Specify range and delimiter
            opts.DataLines = [126, 126];
            opts.Delimiter = ",";

            % Specify column names and types
            opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Morethan1monthto6months5", "Var8", "Var9", "Var10"];
            opts.SelectedVariableNames = "Morethan1monthto6months5";
            opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "string", "string", "string"];
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 8, 9, 10], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 8, 9, 10], "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";

            % Import the data
            loan = readtable(filepath, opts);
            loan = loan{:,"Morethan1monthto6months5"};
        end
%%
        function [bank_code,bank_name] = get_bank_code(obj,file_name)
             % Extract bank_code from file name
             bank_code=split(file_name,".");
             bank_code = strtrim(bank_code(1));
             bank_name ='';
             
             % extract bank_name using mapping
             if strcmp(bank_code,'333107')
                    bank_name='Capitec';
             elseif strcmp(bank_code,'25054') 
                    bank_name='Investec';
             elseif strcmp(bank_code,'34118') 
                    bank_name='ABSA';
             elseif strcmp(bank_code,'416053') 
                    bank_name='FNB';
             elseif strcmp(bank_code,'416061') 
                    bank_name='Standard Bank';
             elseif strcmp(bank_code,'416088')
                    bank_name='Nedbank';
             else
                 bank_name='Other';
             end
        end
%%
        function deposit_total = get_deposit_total(obj,filepath)
            % Import Options
            opts = delimitedTextImportOptions("NumVariables", 10);

            % Specify range and delimiter
            opts.DataLines = [7, 7];
            opts.Delimiter = ",";

            % Specify column names and types
            opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "TOTAL7", "Var10"];
            opts.SelectedVariableNames = "TOTAL7";
            opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "double", "string"];
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 10], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 10], "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            deposit_total = readtable(filepath, opts);
            deposit_total=deposit_total{:,"TOTAL7"};
            
        end
%% 
        function loan_total = get_loan_total(obj,filepath)
            opts = delimitedTextImportOptions("NumVariables", 10);

            % Specify range and delimiter
            opts.DataLines = [126, 126];
            opts.Delimiter = ",";

            % Specify column names and types
            opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Morethan1monthto6months5", "Var8", "Var9", "Var10"];
            opts.SelectedVariableNames = "Morethan1monthto6months5";
            opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "string", "string", "string"];
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 8, 9, 10], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 8, 9, 10], "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            loan_total = readtable(filepath, opts);
            loan_total=loan_total{:,"Morethan1monthto6months5"};
            
        end
    end
end
