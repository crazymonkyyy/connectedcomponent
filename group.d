unittest{
  mixin(import("group.mix"));
  bool not3(int x){return x!=3;}
  int groupidgen;
  int[5] bar;
  grouping!(int*,not3,groupidgen)[5] foo;
  foreach(i;0..5){bar[i]=i ;foo[i]=&bar[i];}
  foreach(i;0..4){foo[i]=foo[i+1];}
  import std.stdio;
  foo.writeln;
}