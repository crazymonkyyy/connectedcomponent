unittest{
  mixin(import("group.mix"));
  bool not3(int x){return x!=3;}
  int groupidgen;
  grouping!(int,not3)[5] foo;
  foreach(i;0..5){foo[i]=i;}
  foreach(i;0..4){foo[i]=foo[i+1];}
  import std.stdio;
  foo.writeln;
}