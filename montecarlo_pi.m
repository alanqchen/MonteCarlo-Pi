%*****************************************
%* Name: Alan Chen                       * 
%*****************************************

clear;
clc;
close all;

% Loop through 1e3, 1e4, 1e5, and 1e6. 1e(n+2)
for n=1:4
    % Init under-curve counter to 0
    underCurve = 0;
    % Create figure
    figure(10^(n+2));
    % Plot points on same plot
    hold on
    % Create plot objects to reuse so that when the figure is plotted with new data, 
    % the set() function can be used so a new plot object isn't created every point.
    % plot object 1 contains points inside the  circle
    plotObj1 = plot(NaN,NaN);
    % plot object 2 contains points outside the circle
    plotObj2 = plot(NaN,NaN);
    % Set points inside the circle to be red
    set(plotObj1,'Color','red','Marker','.','linestyle','none');
    % Set points outside the circle to be blue
    set(plotObj2,'Color','blue','Marker','.','linestyle','none');
    
    % Get current axis of current figure
    ax = gca;
    % Get size and location of axis (includes labels and margin)
    outerpos = ax.OuterPosition;
    % Get margin of axis
    ti = ax.TightInset; 
    % Resize and position plot such that it has "tight" margins and is a square.
    % [left bottom width height]
    ax.Position = [outerpos(1)+5*ti(1) outerpos(2)+ti(2) outerpos(3)-9*ti(1)-ti(3) outerpos(4)-2.5*(ti(1)+ti(4))];
    axis([-.5,.5,-.5,.5]);
    
    % Pre-allocate the x and y vectors with an oversized size so the vectors
    % aren't resized constantly for a large number of points. The unused data
    % in the vectors doesn't effect the calculations, and are plotted outside
    % the window of the plot. (in theory)
    % x1,y1 is for points inside the circle
    x1 = ones(1,10^(n+2));
    y1 = ones(1,10^(n+2));
    % Init counter to keep track of current index in vector to set new points
    plot1Count = 1;
    % x2,y2 is for points outside the circle
    x2 = ones(1,10^(n+2));
    y2 = ones(1,10^(n+2));
    % Init counter to keep track of current index in vector to set new points
    plot2Count = 1;
    
    % Create annotation objects and set basic parameters of them.
    % Annotations are used as textboxes to display the current values.
    aObj1 = annotation('textbox', [.165, .99, 0, 0], 'string', "N under curve: ",'FitBoxToText','on');
    aObj2 = annotation('textbox', [.385, .99, 0, 0], 'string', "Simulated value: ",'FitBoxToText','on');
    aObj3 = annotation('textbox', [.62, .99, 0, 0], 'string', "Percent Error: ",'FitBoxToText','on');
    % Start timer
    tic()
    % Loop through every point
    for i=1:10^(n+2)
        % Generate random points in the range (-.5,-.5) to (.5,.5)
        x = rand()-.5;
        y = rand()-.5;
        % Since the circle plotted is of radius .5 and centered at the origin,
        % the test if the point is under the curve is x^2+y^2<=.25
        if x^2+y^2 <= .25
            % Add the new random point to the inside-circle position vectors
            x1(plot1Count) = x;
            y1(plot1Count) = y;
            % Increment inside-circle and index counters
            underCurve = underCurve + 1;
            plot1Count = plot1Count + 1;
        else
            % Add the new random point to the outside-circle position vectors
            x2(plot2Count) = x;
            y2(plot2Count) = y;
            % Increment index counter
            plot2Count = plot2Count + 1;
        end
        % Only redraw plot every 7^n points (to speed up execution time)
        if mod(i,7^n) == 0
            % Update plot object 1 with current inside-circle position vectors
            set(plotObj1,'XData',x1);
            set(plotObj1,'YData',y1);
            % Update plot object 2 with current outside-circle position vectors
            set(plotObj2,'XData',x2);
            set(plotObj2,'YData',y2);
            % Calculate current simulated value
            simulated = (underCurve/((i)))*4;
            % Calculate current percent error
            percentError = (abs(pi()-simulated)/pi())*100;
            % Set the value of the annotation objects to display the updated
            % values
            set(aObj1,'string',strcat("N under curve: ",num2str(underCurve)));
            set(aObj2,'string',strcat("Simulated value: ",num2str(simulated)));
            set(aObj3,'string',strcat("Percent Error: ",num2str(percentError),'%'));
            % redraw plot
            drawnow;
        end
    end
    % Calculate final simulated value
    simulated = (underCurve/((10^n)*100))*4;
    % Calculate final percent error
    percentError = (abs(pi()-simulated)/pi())*100;
    % Set the value of the annotation objects to display the final values
    set(aObj1,'string',strcat("N under curve: ",num2str(underCurve)));
    set(aObj2,'string',strcat("Simulated value: ",num2str(simulated)));
    set(aObj3,'string',strcat("Percent Error: ",num2str(percentError),'%'));
    % Stop plotting points on same plot
    hold off
    % Stop timer
    t = toc();
    % Display simulation time in command window
    fprintf('Simulation time (s): %f\n', t);
end
