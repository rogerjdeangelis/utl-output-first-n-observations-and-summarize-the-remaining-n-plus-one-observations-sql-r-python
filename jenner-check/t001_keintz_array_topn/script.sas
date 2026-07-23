/* Solution 00 from the repo: Keintz array method (no sort).
   Output the top &N market shares, summarize the remaining N+1 as "Rest".
   The DATA want step is verbatim from upstream; the only edit is pointing the
   library at WORK (sd1.have -> have) instead of the author's d:/sd1 path.
   The upstream inline cards4 block is kept so the bundle is self-contained. */

data have;
  input company$ employees market_share;
cards4;
A  150         0.20
B  200         0.05
C  320         0.45
D  800         0.25
E  450         0.05
;;;;
run;

%let n=3;

data want (keep=company market_share var1);
  set have(rename=employees=var1) end=end_of_have;
  array comp {&N} $19 _temporary_ ;
  array shrs {&N}     _temporary_ ;
  array v1   {&N}     _temporary_ ;
  retain   rnk&N . ;
  total + market_share;
  totalv1 + var1;
  if market_share>rnk&N then do;
    if _n_<=&N then i=_n_;
    else i=whichn(rnk&N,of shrs{*});
    comp{i} = company;
    shrs{i} = market_share;
    v1{i} = var1;
    if _n_>=&N then rnk&N = min(of shrs{*});
  end;
  if end_of_have;
  do r=1 to &N;
    market_share=largest(r,of shrs{*});
    i=whichn(market_share,of shrs{*});
    company=comp{i};
    var1=v1{i};
    output;
  end;
  company=cat('Rest (',_n_-&N,')');
  market_share = total-sum(of shrs{*});
  var1 =  (totalv1-sum(of v1{*}))/(_n_-&N);
  output;
run;

proc print data=want;
run;quit;
