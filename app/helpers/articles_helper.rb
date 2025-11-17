module ArticlesHelper
    def getLastRender(component, page)
        lastrender = 0;
        if page == 1 
            lastrender = 0;
            return lastrender;
        end
        seperatorCounter = 1;
        component.each.with_index do |c,i|
            if c.key?("type") && c["type"] == "Page"
                seperatorCounter = seperatorCounter+1;
                if (seperatorCounter == page.to_i) 
                    lastrender = i + 1;
                    break;
                end
            end
        end

        return lastrender;
    end

    def pgAmount(components)
        pageAmount =  0 ;
        components.each.with_index do |c,i|
            if c.key?("pageAmount")
                pageAmount = c["pageAmount"] +1
                break
            end
        end 
        return pageAmount;
    end

    def getImageClass(g, gridCounter)
        grid = g.to_i
        
        if grid.to_i > 1 
            size = 12 / grid;
            puts gridCounter.inspect
            direction = gridCounter % 2 == 0 ? "even" : "odd";
            mainDivClass = "col-xs-12 col-sm-" + size.to_s;
            mainDivClass += " img-grid " + direction;
            gridCounter = gridCounter + 1;
        else 
            mainDivClass = " ";
        end
        return mainDivClass, gridCounter 
    end
end
