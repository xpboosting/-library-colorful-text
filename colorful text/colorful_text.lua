local client_color_log, type = client.color_log, type;

local colorful_text = {};

colorful_text.lerp = function(self, from, to, duration)
    if type(from) == 'table' and type(to) == 'table' then
        return { 
            self:lerp(from[1], to[1], duration), 
            self:lerp(from[2], to[2], duration), 
            self:lerp(from[3], to[3], duration) 
        };
    end

    return from + (to - from) * duration;
end

colorful_text.console = function(self, ...)
    for i, v in ipairs({ ... }) do
        if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
            for k = 1, #v[3] do
                local l = self:lerp(v[1], v[2], k / #v[3]);
                client_color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
            end
        elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
            client_color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
        end
    end
end

colorful_text.text = function(self, ...)
    local menu = false;
    local alpha = 255
    local f = '';
    
    for i, v in ipairs({ ... }) do
        if type(v) == 'boolean' then
            menu = v;
        elseif type(v) == 'number' then
            alpha = v;
        elseif type(v) == 'string' then
            f = f .. v;
        elseif type(v) == 'table' then
            if type(v[1]) == 'table' and type(v[2]) == 'string' then
                f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
            elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local g = self:lerp(v[1], v[2], k / #v[3])
                    f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                end
            end
        end
    end

    return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
end

colorful_text.log = function(self, ...)
    for i, v in ipairs({ ... }) do
        if type(v) == 'table' then
            if type(v[1]) == 'table' then
                if type(v[2]) == 'string' then
                    self:console({ v[1], v[1], v[2] })
                    if (v[3]) then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                elseif type(v[2]) == 'table' then
                    self:console({ v[1], v[2], v[3] })
                    if v[4] then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                end
            elseif type(v[1]) == 'string' then
                self:console({ { 205, 205, 205 }, v[1] });
                if v[2] then
                    self:console({ { 255, 255, 255 }, '\n' })
                end
            end
        end
    end
end

return colorful_text;
