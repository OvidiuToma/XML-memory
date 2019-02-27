- ./script_example.sh
  - Iterative example that stores the xml into a single wrapper
  - MEMORY USAGE(MB): 337
- ./script_example.sh -r -o
  - Recursive example that optimized so it won’t halt execution. It calls the recursive function with a fresh nokogiri builder wrapper.
  - MEMORY USAGE(MB): 335
- ./script_example.sh -r -so
  - Recursive example that calls the recursive function with a fresh nokogiri wrapper and appens the profile to the xml file.
  - MEMORY USAGE(MB): 30
- ./script_example.sh -r 
  - Recursive example that calls the recursive method with the main nokogiri builder wrapper and causes the garbage collector to halt. 
  - MEMORY USAGE(MB): 426
  - The ruby script doesn't exit, like never. 



