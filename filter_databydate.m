function filtered_data = filter_databydate(start_date, end_date)

    data = read_clean_data();
    % Filter data based on selected date range
    dates_in_range = (data.Date >= start_date) & (data.Date < end_date);
    filtered_data = data(dates_in_range,:);
end
