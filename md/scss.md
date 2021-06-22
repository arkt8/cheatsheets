$my-color: #034; body {color:$my-color}			variable
@use myfile; // load _myfile.scss				partials, include files
@mixin x($arg) { prop:$arg; }					mixin for repetitive works
%my {color:#fff;} .message{@extend:%my;}		extend declaration for multiple selectors
width:600px / 960px * 100%  => width:62.5%		operators or math

