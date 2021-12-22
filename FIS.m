%% Clear data
clc,clear

%% Select input variables

data=readtable('value.csv');
days=table2array(data(:,1));
sales=table2array(data(:,2));
cust=table2array(data(:,3));
elect=table2array(data(:,4));
groc=table2array(data(:,5)); %
comp=table2array(data(:,6));

min(sales); % 95.6
max(sales); % 103.9
min(cust); % 96.7
max(cust); % 103.3
min(elect); %96.3 
max(elect); % 103.6
min(groc); %96.7
max(groc); %102.8
min(comp); %95.6
max(comp); %104.2

figure(1),subplot(2,2,1)
    line(days,cust)
    title('Days vs. Customer'), xlabel('Days'),ylabel('Customer')
figure(1),subplot(2,2,2)
    plot(days,elect)
    title('Days vs. Electronics'), xlabel('Days'),ylabel('Electronics')
figure(1),subplot(2,2,3)
    plot(days,groc)
    title('Days vs. Groceries'), xlabel('Days'),ylabel('Groceries')
figure(1),subplot(2,2,4)
    plot(days,comp)
    title('Days vs. Competitions'), xlabel('Days'),ylabel('Competitions')


figure(2),subplot(2,2,1)
    plot(sales,cust)
    title('Sales vs. Customer'), xlabel('Sales'),ylabel('Customer')
figure(2),subplot(2,2,2)
    plot(sales,elect)
    title('Sales vs. Electronics'), xlabel('Sales'),ylabel('Electronics')
figure(2),subplot(2,2,3)
    plot(sales,groc)
    title('Sales vs. Groceries'), xlabel('Sales'),ylabel('Groceries')
figure(2),subplot(2,2,4)
    plot(sales,comp)
    title('Sales vs. Competitions'), xlabel('Sales'),ylabel('Competitions')
 
tbl=tabulate(cust);
figure(3), corrplot(data);


%% Choice of Groceries, Electronics as input

prompt = {'Does your store sell Electronics or Groceries (0/1):','Enter number of stores to be compared:'};
title = 'About the Stores';
choice = inputdlg(prompt,title);
ch = str2double(choice{1});
n= str2double(choice{2}); % Asking for number of stores for which rating is to be compared
list_names = string.empty(n,0);
list_cust = double.empty(n,0);
list_elect = double.empty(n,0);
list_comp = double.empty(n,0);

%% Taking input data
for i = 1:n
    if ch == 0 %electronics
        prompt = {'Enter Store name:','Enter daily customers rating [0-10]:','Enter electronic items rating [0-10]:','Enter number of competitors rating [0-10]:'};
    else
        prompt = {'Enter Store name:','Enter daily customers rating [0-10]:','Enter groeries items rating [0-10]:','Enter number of competitors rating [0-10]:'};
    end
    title = 'Find Store Ratings';
    answer = inputdlg(prompt,title);
    name = answer{1};
    cust = str2double(answer{2});
    elect = str2double(answer{3});
    comp = str2double(answer{4});
    
    list_names(i) = name;
    list_cust(i) = cust;
    list_elect(i)= elect;
    list_comp(i)   = comp;    
end

disp(list_names)
disp(list_cust)
disp(list_elect)
disp(list_comp)

%% Opening FIS created using Fuzzy Logic Toolbox
if ch == 0 %electronics
    fismat = readfis('FIS1');
else
    fismat = readfis('FIS2');
end
inputdat = transpose(cat(1,list_cust,list_elect,list_comp));
if n == 1
    out = evalfis(fismat,inputdat);
else
    out = evalfis(fismat,inputdat,n);
end    
disp(inputdat);
disp(out);

%% Finding maximum rating

if (n == 1)
    disp("Only one store was given");
else
    [max_num, max_ind] = max(out(:));
    %sprintf('Best store is %s ',list_names(max_ind));
    disp('Best Store is ');
    disp(list_names(max_ind));
end
