struct grouping(T,alias filter,alias groupidgen){
  T payload;
  typeof(++groupidgen) group=0;
  void opAssign(S)(S a){
    if(filter(*a)){
      payload=a;
      group=++groupidgen;
    }
  }
  bool isnull(){return group==0;}
  void opAssign(ref typeof(this) a){
    if(!isnull && !a.isnull){
      import std.algorithm;
      a.group=min(a.group,group);
      group=min(a.group,group);
  }}
  auto get(){
    assert(!isnull);
    return payload;
  }
  alias get this;
}