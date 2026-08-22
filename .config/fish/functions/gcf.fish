function gcf --wraps='g++ -Wall -Wextra -Wconversion -Wfloat-equal -Wduplicated-cond -Wlogical-op -std=c++17 -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG' --description 'alias gcf g++ -Wall -Wextra -Wshadow -Wconversion -Wfloat-equal -Wduplicated-cond -Wlogical-op -std=c++17 -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG'
  g++ -Wall -Wextra -Wconversion -Wfloat-equal -Wduplicated-cond -Wlogical-op -std=c++17 -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG $argv
        
end
