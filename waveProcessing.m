clear all
data = dlmread("wave.txt","emptyvalue", 100);
data(data==0)=NaN;

timesMillis = data(:,1);

x = data(:,2:2:end);
y = data(:,3:2:end);

for i = 1:rows(data)
  plot(x(i,:), y(i,:))
  set(gca, "ylim", [1, 8])
  pause(0.2);
endfor