unittest{
  mixin(import("group.mix"));
  int groupidgen;
  int[5] bar;
  grouping!(int*,"*a!=3")[5] foo;
  foreach(i;0..5){bar[i]=i ;foo[i]=&bar[i];}
  foreach(i;0..4){foo[i]=foo[i+1];}
  import std.stdio;
  foo.writeln;
}