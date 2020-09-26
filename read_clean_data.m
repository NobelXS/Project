function data = read_clean_data()
    opts = delimitedTextImportOptions("NumVariables", 8);

    % Specify range and delimiter
    opts.DataLines = [1, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["Date", "Bank_Code", "Bank_Name", "Deposits", "Loans", "Loan_Deposit_Ratio", "Market_Share_Deposits", "Market_Share_Loans"];
    opts.VariableTypes = ["datetime", "double", "categorical", "double", "double", "double", "double", "double"];
    opts = setvaropts(opts, 1, "InputFormat", "dd-MMM-yyyy");
    opts = setvaropts(opts, 3, "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Import the data
    data = readtable("C:\Users\Nobel X\Desktop\Project\Data\Clean.csv", opts);
end

