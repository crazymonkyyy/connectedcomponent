
unittest{
  struct stable(T){
    T payload;
    void opAssign(S)(S a){
      T temp=payload;
      payload=a;
      if(temp!=payload){unstables+=&this;}
    }
    alias payload this;
  }
  struct foo{
    void opOpAssign(string op,T)(T a){}
  }
  size_t groupidgen;
  struct grouping(T){
    T payload;
    size_t group=0;
    void opAssign(S)(ref S a){
      payload=a;
      group=++groupidgen;
    }
    void opAssign(ref typeof(this) a){
      if(group!=0 && a.group!=0){
        import std.algorithm;
        a.group=min(a.group,group);
        group=min(a.group,group);
      }
    }
    alias payload this;
  }
  foo unstables;
  stable!(grouping!int) bar;
  bar=1;
  //bar=stable!(grouping!int)(grouping!int(1));
}