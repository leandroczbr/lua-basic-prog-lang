---------- testing with fibonacci sequence
package.path = package.path .. ";C:\Program Files (x86)\MyApp\?.lua" --example path
lbpl = require "luabasic-pl"

lbpl.run(
    [[
    set first 0;
    set second 1;
    set next 0;
    add next first second;
    print first;
    print second;
    print next;
    
    set index 0;
    set max 10;
    set continue true;
    :loop
        set first second;
        set second next;
        set next 0;
        add next first second;
        print next;
        add index 1;
        big continue max index;
    ifgt continue loop;
]])
