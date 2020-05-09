T*[][] connectedcomponentfilter(alias filter,T,size_t x,size_t y)(ref T[x][y] data){
  struct stable(T){
    T payload;
    bool isstable=false;
    void opAssign(S)(S a){
      T temp=payload;
      payload=a;
      if(temp!=payload){isstable=false; unstables+=&this;}
    }
    alias payload this;
  }
  size_t groupidgen;
  struct grouping(T){
    T payload;
    size_t group=0;
    void opAssign(S)(S a){
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
  import ringarray;
  import smart2darray;
  alias elemtype=stable!(grouping!(T*));
  ring!(elemtype*,true,x+y,donothing) unstables;//x+y is a randomly choosen heristic, that seems like a good idea at this moment
  array2d!(elemtype,x,y) groupfindingdata;
  //import std.stdio; "hi".writeln;
  init:
  foreach(i;0..x){
  foreach(j;0..y){//didnt check if this is the cashe friendly order
    groupfindingdata[i,j]=&data[i][j];
  }}
  //unstables.tail=unstables.head;
  
  groupandstablize: bool allstable=true;
  foreach(i;0..x){
  foreach(j;0..y){
    import std.stdio; writeln(i,",",j);
    void group(vec2)(vec2 a){
      alias g=groupfindingdata;
      if(a.x+1<x){g[a.x,a.y]=*g[a.x+1,a.y  ];}
      if(a.x-1>0){g[a.x,a.y]=*g[a.x-1,a.y  ];}
      if(a.y+1<y){g[a.x,a.y]=*g[a.x  ,a.y+1];}
      if(a.y-1>0){g[a.x,a.y]=*g[a.x  ,a.y-1];}
    }
    while(!unstables.empty){
      allstable=false;
      group(groupfindingdata[unstables]);
    }
    {
      struct vec2{int x; int y;} 
      group(vec2(x,y));
    }
  }}
  
  T*[][] bar;
  return bar;
}
unittest{
  auto iseven(int a){return a%2==0;}
  int[3][3] foo=[
    [1,2,3],
    [1,2,3],
    [1,2,3] ];
  auto bar=connectedcomponentfilter!(iseven)(foo);
}

  /*size_t i;
  struct filteringpointers{
    T* payload;
    size_t group;
    void opAssign(ref T a){
      payload=&a;
      bool exist=filter(a);
      if (exist){group=i++;}
      else {group=0;}
    }
    void grouping(size_t myx,size_t myy){
      if (group==0){goto end;}
      start:size_t temp=group;
      if (myx > 1  ){this.test(myx-1,myy  );}
      if (myx < x-2){this.test(myx+1,myy  );}
      if (myy < 1  ){this.test(myx  ,myy-1);}
      if (myy < y-2){this.test(myx  ,myy+1);}
      if(temp!=group){goto start;}
      end:
    }
    alias payload this;
  }
  filteringpointers[x][y] smartdata;
  void test(filteringpointers a,size_t thierx,size_t thiery){
    if(smartdata[thierx][thiery].group==0        || 
        smartdata[thierx][thiery].group==a.group ||
        a.group==0){}
    else{
      if(smartdata[thierx][thiery].group > a.group){
        smartdata[thierx][thiery].group = a.group;
        smartdata[thierx][thiery].grouping(thierx,thiery);
      }
      else{
        a.group=smartdata[thierx][thiery].group;
      }
    }
  } */