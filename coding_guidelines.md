// Coding Guidelines

1. Restrict the code to 100 characters - Use below in your .vimrc file:
      " Setting the colum width 
      highlight ColorColumn ctermbg=gray
      set colorcolumn=100
2. Only one statement per line.
      // Variable definition:
      logic enable;
      logic completed;
      logic in_progress;
3. Always use a begin-end pair to bracket conditional statements:
      // Both statements executed conditionally:
      if(i>0)begin
        count= current_count;
        target= current_target;
      end     
4. Use lowercase for names, using underscores to separate fields:
     axi_fabric_scoreboard_error
5. Use the end label for classes, functions, tasks etc., called closing identifiers. Ex: 
      function name ()
      endfunction: Name
6. Use prefix_ and _postfix to delineate name types:
      prefix/postfix	Purpose
      _t	            Used for a type created via a typedef
      _e	            Used to indicate a enumerated type
      _h	            Used for a class handle
      _m	            Used for a protected class member (See guideline 2.2)
      _cfg	          Used for a configuration object handle
      _ap	            Used for an analysis port handle
      _group	        Used for a covergroup handle  
7. All structs, unions and enums. They should use camelCase with the following distinction:
      Structs end with _s
      Unions end with _u
      Enums end with _e. Additionally, enumerations should use UPPERCASE_WITH_UNDERSCORES. 
      enum { IPV4_TCP, IPV4_UDP} packetType_e;
8. Use a descriptive typedef when declaring a variable instead of a built-in type:
      // Descriptive typedef for a 24 bit audio sample:
      typedef bit[23:0] audio_sample_t;
9. Declare class methods using extern:
      extern function new(string name);
      extern function results_t get_results();
10. Check that $cast() has succeeded:
      if(!$cast(t, to_be_cloned.clone())begin
        `uvm_error("get_a_clone","$cast failed for to_be_cloned")
      end
11. Use "if" rather than "assert" to check the status of method calls.
12. Check that randomize() has succeeded:
      // Using if() to check randomization result 
      // DON'T use assert as they can be turned-off
      if(!seq_item.randomize() with {addressinside{[0:32'hF000_FC00]};}) begin
        `uvm_error("seq_name","randomization failure, please check constraints")
      end
13. Always declare functions/tasks to be virtual. Helps in using Polymorphism feature.
14. Do not use associative arrays with a wildcard index[*]:
      string names[*];// cannot be used with foreach, find_index, ...
      string names[int];
15. Do not use #0 procedural delays:
      Often, using a non-blocking assignment ( <= ) solves this class of problem.
16. Do not use hard-coded values. Always use constants/parameters. 
17. Always use one-class definition per file.
18. Keep the file name same as the class name.
You can use more coding guidlines by referring the below link, however, the above mentioned guidelines must be followed!
