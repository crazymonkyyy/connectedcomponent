T*[][] connectedcomponentfilter(alias filter,T,size_t x,size_t y)(ref T[x][y] data){
  size_t i;
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
  }
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