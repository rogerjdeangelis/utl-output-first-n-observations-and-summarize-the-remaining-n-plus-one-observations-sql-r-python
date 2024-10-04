    %let pgm=utl-output-first-n-observations-and-summarize-the-remaining-n-plus-one-observations-sas-r-python;

    Output first n observations and summarize the remaining n plus one observations sas r python

       SOLUTIONS

         00 sas datastep no sort
            Keintz, Mark
            mkeintz@outlook.com

         0  sas hash (not my strong point)

         1  SAS defer table (solution not easily done in sas sql)
         2  r dplyr
         3  r sql
         4  r nested sql
         5  python sql

    github
    https://tinyurl.com/hhs3js4n
    https://github.com/rogerjdeangelis/utl-output-first-n-observations-and-summarize-the-remaining-n-plus-one-observations-sql-r-python

    stackoverflow
    https://tinyurl.com/54je9a3c
    https://stackoverflow.com/questions/79046886/expose-only-first-n-records-from-data-frame-and-create-a-summary-row-for-the-rem

    /*               _     _
     _ __  _ __ ___ | |__ | | ___ _ __ ___
    | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
    | |_) | | | (_) | |_) | |  __/ | | | | |
    | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
    |_|
    */

    /**************************************************************************************************************************/
    /*                               |                                                 |                                      */
    /*        INPUT                  |               PROCESS                           |              OUTPUT                  */
    /*                               |                                                 |                                      */
    /*                               |                                                 |                                      */
    /*                      MARKET_  | 1. output the top 3 market_shares               |                             MARKET_  */
    /* OMPANY  EMPLOYEES     SHARE   | 2  aveage the remainin 2 employee records       |  Obs    COMPANY  EMPLOYEES   SHARE   */
    /*                               | 3  sum the remaing market_share records         |                                      */
    /*   A       150         0.20    |                                                 |   1     C           320       0.45   */
    /*   B       200         0.05    | FIRST SORT THE DATA BY DESCENDING MARKET SHARE  |   2     D           800       0.25   */
    /*   C       320         0.45    |                                                 |   3     A           150       0.20   */
    /*   D       800         0.25    |                        MARKET_                  |   4     THEREST     325       0.10   */
    /*   E       450         0.05    | COMPANY    EMPLOYEES     SHARE                  |                                      */
    /*                               |                                                 |                                      */
    /*                               |  C          320         0.45  output            |                                      */
    /*                               |  D          800         0.25  output            |                                      */
    /*                               |  A          150         0.20  output            |                                      */
    /*                               |                                                 |                                      */
    /*                               |  B          200         0.05  Summarize 3+1 obs |                                      */
    /*                               |  E          450         0.05                    |                                      */
    /*                               |  ============================                   |                                      */
    /*                               |         AVG 325     SUM 0.10                    |                                      */
    /*                               |                                                 |                                      */
    /*                               |-------------------------------------------------|                                      */
    /*                               |                                                 |                                      */
    /*                               | SAS SOLUTION                                    |                                      */
    /*                               | ============                                    |                                      */
    /*                               |                                                 |                                      */
    /*                               | data want;                                      |                                      */
    /*                               |   retain sum avg  n 0;                          |                                      */
    /*                               |   set   sd1.have(obs=0)                         |                                      */
    /*                               |         havsrt open=defer end=dne;              |                                      */
    /*                               |    %dosubl(' /* SORT BEFORE DATASTEP */         |                                      */
    /*                               |     proc sql;                                   |                                      */
    /*                               |       create                                    |                                      */
    /*                               |          view havsrt as                         |                                      */
    /*                               |       select                                    |                                      */
    /*                               |          *                                      |                                      */
    /*                               |       from                                      |                                      */
    /*                               |         sd1.have                                |                                      */
    /*                               |      order                                      |                                      */
    /*                               |         by market_share desc                    |                                      */
    /*                               |     ;quit;                                      |                                      */
    /*                               |     ');                                         |                                      */
    /*                               |   if _n_< 4 then output; /* output top 3 */     |                                      */
    /*                               |   else do;                                      |                                      */
    /*                               |     sum=sum+market_share;                       |                                      */
    /*                               |     avg= avg + employees;                       |                                      */
    /*                               |     n=n+1;                                      |                                      */
    /*                               |   end;                                          |                                      */
    /*                               |   if dne then do;                               |                                      */
    /*                               |     company="THEREST";                          |                                      */
    /*                               |     employees=avg/n;                            |                                      */
    /*                               |     market_share=sum;                           |                                      */
    /*                               |     output;                                     |                                      */
    /*                               |   end;                                          |                                      */
    /*                               |   drop sum avg n;                               |                                      */
    /*                               | run;quit;                                       |                                      */
    /*                               |                                                 |                                      */
    /                                |-------------------------------------------------|                                      */
    /*                               |                                                 |                                      */
    /*                               | R DPLYR SOLUTION                                |                                      */
    /*                               | ================                                |                                      */
    /*                               |                                                 |                                      */
    /*                               | want<-have %>%                                  |                                      */
    /*                               |   arrange(desc(MARKET_SHARE)) %>%               |                                      */
    /*                               |   mutate(grp = c(seq_len(rec)                   |                                      */
    /*                               |     ,rep(rec + 1, n() - rec))) %>%              |                                      */
    /*                               |   summarize(COMPANY =                           |                                      */
    /*                               |    ifelse(n() > 1, "Rest", COMPANY[1])          |                                      */
    /*                               |      ,EMPLOYEES = mean(EMPLOYEES)               |                                      */
    /*                               |      ,MARKET_SHARE = sum(MARKET_SHARE)          |                                      */
    /*                               |      ,.by = grp) %>%                            |                                      */
    /*                               |     select(-grp)                                |                                      */
    /*                               |                                                 |                                      */
    /**************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

    options validvarname=upcase;
    libname sd1 "d:/sd1";
    data sd1.have;
      input company$ employees market_share;
    cards4;
    A  150         0.20
    B  200         0.05
    C  320         0.45
    D  800         0.25
    E  450         0.05
    ;;;;
    run;quit;

    /*___      _       _            _                                           _
     / _ \  __| | __ _| |_ __ _ ___| |_ ___ _ __    _ __   ___   ___  ___  _ __| |_
    | | | |/ _` |/ _` | __/ _` / __| __/ _ \ `_ \  | `_ \ / _ \ / __|/ _ \| `__| __|
    | |_| | (_| | (_| | || (_| \__ \ ||  __/ |_) | | | | | (_) |\__ \ (_) | |  | |_
     \___/ \__,_|\__,_|\__\__,_|___/\__\___| .__/  |_| |_|\___/ |___/\___/|_|   \__|
                                           |_|
    */


    %let n=3;

    data want (keep=company market_share var1);
      set sd1.have(rename=employees=var1) end=end_of_have;
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

     /**************************************************************************************************************************/
     /*                                                                                                                        */
     /* p to 40 obs from last table WORK.WANT total obs=4 04OCT2024:14:06:14                                                   */
     /*                                                                                                                        */
     /*                           MARKET_                                                                                      */
     /* bs    COMPANY     VAR1     SHARE                                                                                       */
     /*                                                                                                                        */
     /* 1     C            320      0.45                                                                                       */
     /* 2     D            800      0.25                                                                                       */
     /* 3     A            150      0.20                                                                                       */
     /* 4     Rest (2)     325      0.10                                                                                       */
     /*                                                                                                                        */
     /**************************************************************************************************************************/

    /*___   ___                    _               _
     / _ \ / _ \   ___  __ _ ___  | |__   __ _ ___| |__
    | | | | | | | / __|/ _` / __| | `_ \ / _` / __| `_ \
    | |_| | |_| | \__ \ (_| \__ \ | | | | (_| \__ \ | | |
     \___/ \___/  |___/\__,_|___/ |_| |_|\__,_|___/_| |_|

    */

    data tbl_sort(keep=company employees market_share);

        retain rec sum avg recs 0 rest 'THEREST';

        if 0 then set sd1.have nobs=numobs;

        declare hash sortha(dataset: 'sd1.have', ordered: 'd');
        declare hiter iter('sortha');
        sortha.definekey('market_share','company');
        sortha.definedata('company','market_share','employees');
        sortha.definedone();

        recs=numobs;

        do while (iter.next() = 0);
           rec=rec+1;
           if rec <= 3 then do;
              output tbl_sort;
           end;
           else do;
              avg=avg + employees/(numobs-3);
              sum=sum + market_share;
              if rec=numobs then do;
                 company='THEREST';
                 market_share=sum;
                 employees=avg;
                 output tbl_sort;
              end;
           end;
        end;
    run;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* WORK.TBL_SORT total obs=4                                                                                              */
    /*                                                                                                                        */
    /*                                MARKET_                                                                                 */
    /* Obs    COMPANY    EMPLOYEES     SHARE                                                                                  */
    /*                                                                                                                        */
    /*  1     C             320         0.45                                                                                  */
    /*  2     D             800         0.25                                                                                  */
    /*  3     A             150         0.20                                                                                  */
    /*  4     THEREST       325         0.10                                                                                  */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*                       _       __
    / |  ___  __ _ ___    __| | ___ / _| ___ _ __
    | | / __|/ _` / __|  / _` |/ _ \ |_ / _ \ `__|
    | | \__ \ (_| \__ \ | (_| |  __/  _|  __/ |
    |_| |___/\__,_|___/  \__,_|\___|_|  \___|_|

    */

    proc datasets lib=work mt=data mt=view nolist nodetails;
     delete  havsrt ;
    run;quit;

    data want;
      retain sum avg  n 0;
      set   sd1.have(obs=0)
            havsrt open=defer end=dne;
      %dosubl('
        proc sql;
          create
             view havsrt as
          select
             *
          from
            sd1.have
         order
            by market_share desc
        ;quit;
        ');
      if _n_< 4 then output;
      else do;
        sum=sum+market_share;
        avg= avg + employees;
        n=n+1;
      end;
      if dne then do;
        company="THEREST";
        employees=avg/n;
        market_share=sum;
        output;
      end;
      drop sum avg n;
    run;quit;

    proc print data=want;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /*  WANT total obs=4                                                                                                      */
    /*                                 MARKET_                                                                                */
    /*  Obs    COMPANY    EMPLOYEES     SHARE                                                                                 */
    /*                                                                                                                        */
    /*   1     C             320         0.45                                                                                 */
    /*   2     D             800         0.25                                                                                 */
    /*   3     A             150         0.20                                                                                 */
    /*   4     THEREST       325         0.10                                                                                 */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*___               _             _
    |___ \   _ __    __| |_   _ _ __ | |_ __
      __) | | `__|  / _` | | | | `_ \| | `__|
     / __/  | |    | (_| | |_| | |_) | | |
    |_____| |_|     \__,_|\__, | .__/|_|_|
                          |___/|_|
    */

    proc datasets lib=sd1 mt=data mt=view nolist nodetails;
     delete  rwant ;
    run;quit;

    %utl_rbeginx;
    parmcards4;
    library(haven)
    library(dplyr)
    source("c:/oto/fn_tosas9x.R")
    have<-read_sas("d:/sd1/have.sas7bdat")
    rec <- 3
    want<-have %>%
      arrange(desc(MARKET_SHARE)) %>%
      mutate(grp = c(seq_len(rec)
        ,rep(rec + 1, n() - rec))) %>%
      summarize(COMPANY =
       ifelse(n() > 1, "Rest", COMPANY[1])
         ,EMPLOYEES = mean(EMPLOYEES)
         ,MARKET_SHARE = sum(MARKET_SHARE)
         ,.by = grp) %>%
        select(-grp)
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rwant"
         )
    ;;;;
    %utl_rendx;

    proc print data=sd1.rwant;
    run;quit;

    /**************************************************************************************************************************/
    /*                                        |                                                                               */
    /* R                                      |  SAS                                                                          */
    /*                                        |                                                                               */
    /*  # A tibble: 4 Ã— 3                    |                                       MARKET_                                 */
    /*    COMPANY EMPLOYEES MARKET_SHARE      |   ROWNAMES    COMPANY    EMPLOYEES     SHARE                                  */
    /*    <chr>       <dbl>        <dbl>      |                                                                               */
    /*  1 C             320         0.45      |       1        C            320         0.45                                  */
    /*  2 D             800         0.25      |       2        D            800         0.25                                  */
    /*  3 A             150         0.2       |       3        A            150         0.20                                  */
    /*  4 Rest          325         0.1       |       4        Rest         325         0.10                                  */
    /*                                        |                                                                               */
    /**************************************************************************************************************************/

    /*____                    _
    |___ /   _ __   ___  __ _| |
      |_ \  | `__| / __|/ _` | |
     ___) | | |    \__ \ (_| | |
    |____/  |_|    |___/\__, |_|
                           |_|
    */

    proc datasets lib=sd1 mt=data mt=view nolist nodetails;
     delete  rsql ;
    run;quit;

    %utl_rbeginx;
    parmcards4;
    library(haven)
    library(sqldf)
    source("c:/oto/fn_tosas9x.R")
    have<-read_sas("d:/sd1/have.sas7bdat")
    want <- sqldf('
     with havSrt as (
        select
           *
          ,case
             when partition >3 then 3+1
             else partition
           end as grp
        from
          (select *, row_number() OVER (ORDER BY market_share desc) as partition from have )
        )
     select
        max(company)      as company
       ,avg(employees)    as employees
       ,sum(market_share) as market_share
     from
        havSrt
     group
        by grp
       ')
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rsql"
         )
    ;;;;
    %utl_rendx;


    proc print data=sd1.rsql;
    run;quit;

    /**************************************************************************************************************************/
    /*                                     |                                                                                  */
    /* R                                   | SAS                                                                              */
    /*                                     |                                                                                  */
    /*  > want                             |                                     MARKET_                                      */
    /*    company employees market_share   | ROWNAMES    COMPANY    EMPLOYEES     SHARE                                       */
    /*  1       C       320         0.45   |                                                                                  */
    /*  2       D       800         0.25   |     1          C          320         0.45                                       */
    /*  3       A       150         0.20   |     2          D          800         0.25                                       */
    /*  4       E       325         0.10   |     3          A          150         0.20                                       */
    /*                                     |                                                                                  */
    /**************************************************************************************************************************/

    /*  _                            _           _             _
    | || |    _ __   _ __   ___  ___| |_ ___  __| |  ___  __ _| |
    | || |_  | `__| | `_ \ / _ \/ __| __/ _ \/ _` | / __|/ _` | |
    |__   _| | |    | | | |  __/\__ \ ||  __/ (_| | \__ \ (_| | |
       |_|   |_|    |_| |_|\___||___/\__\___|\__,_| |___/\__, |_|
                                                            |_|
    */

    proc datasets lib=sd1 mt=data mt=view nolist nodetails;
     delete  rnest ;
    run;quit;

    %utl_rbeginx;
    parmcards4;
    library(haven)
    library(sqldf)
    source("c:/oto/fn_tosas9x.R")
    have<-read_sas("d:/sd1/have.sas7bdat")
    want <- sqldf('
     select
        max(company)      as company
       ,avg(employees)    as employees
       ,sum(market_share) as market_share
     from
        (
        select
           *
          ,case
             when partition >3 then 3+1
             else partition
           end as grp
        from
          (select *, row_number() OVER (ORDER BY market_share desc) as partition from have )
        )
     group
        by grp
       ')
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="rnest"
         )
    ;;;;
    %utl_rendx;


    proc print data=sd1.rnest;
    run;quit;

    /**************************************************************************************************************************/
    /*                                     |                                                                                  */
    /* R                                   | SAS                                                                              */
    /*                                     |                                                                                  */
    /*  > want                             |                                     MARKET_                                      */
    /*    company employees market_share   | ROWNAMES    COMPANY    EMPLOYEES     SHARE                                       */
    /*  1       C       320         0.45   |                                                                                  */
    /*  2       D       800         0.25   |     1          C          320         0.45                                       */
    /*  3       A       150         0.20   |     2          D          800         0.25                                       */
    /*  4       E       325         0.10   |     3          A          150         0.20                                       */
    /*                                     |                                                                                  */
    /**************************************************************************************************************************/

    /*___                _   _                             _
    | ___|   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
    |___ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
     ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
    |____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
            |_|    |___/                                |_|
    */

    proc datasets lib=sd1 nolist nodetails;
     delete pywant;
    run;quit;

    %utl_pybeginx;
    parmcards4;
    exec(open('c:/oto/fn_python.py').read());
    have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
    want=pdsql('''
     select
        max(company)      as company
       ,avg(employees)    as employees
       ,sum(market_share) as market_share
     from
        (
        select
           *
          ,case
             when partition >3 then 3+1
             else partition
           end as grp
        from
          (select *, row_number() OVER (ORDER BY market_share desc) as partition from have )
        )
     group
        by grp
       ''');
    print(want);
    fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
    ;;;;
    %utl_pyendx;

    proc print data=sd1.pywant;
    run;quit;

    /**************************************************************************************************************************/
    /*                                      |                                                                                 */
    /*  PYTHON                              | SAS                                                                             */
    /*                                      |                         MARKET_                                                 */
    /*    company  employees  market_share  | COMPANY    EMPLOYEES     SHARE                                                  */
    /*                                      |                                                                                 */
    /*  0       C      320.0          0.45  |    C          320         0.45                                                  */
    /*  1       D      800.0          0.25  |    D          800         0.25                                                  */
    /*  2       A      150.0          0.20  |    A          150         0.20                                                  */
    /*  3       E      325.0          0.10  |    E          325         0.10                                                  */
    /*                                      |                                                                                 */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
