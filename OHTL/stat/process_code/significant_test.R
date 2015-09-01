
library(lsr)
library(R.matlab)

SignificantTest <- function(vector1, vector2, alpha = 0.01)
{
  temp <- t.test(vector1, vector2, paired = TRUE, conf.level = alpha);
  
  t <- temp$statistic;
  df <- temp$parameter;
  p <- temp$p.value;
  interval <- temp$conf.int;
  
  cohens_d <- cohensD(vector1 - vector2)
  r2 <- (t^2) / (t^2 + df);
  
  result <- list();
  if (p >= alpha)
  {
    flag = 0;
  }
  else
  {
    if (mean(vector1) < mean(vector2))
    {
      flag = -1;
    }
    else
    {
      flag = 1;
    }
  }
	
	d_flag = -1;
  if (mean(vector1) > mean(vector2))
  {
    if (cohens_d > 0.8)
    {
      d_flag = 1;
    }
    else if (cohens_d > 0.2)
    {
      d_flag = 0;
    }
  }
  result$flag <- flag;
  result$cohens.d <- d_flag;
  result$r2 <- r2;
  
  return(result);
  
}

main <- function(directory)
{
	#directory = {'eoc', 'eos_image', 'eos_text'}

	num.methods <- 6;

	for (iter in 1 : 21)
	{
  
  result.table <- matrix(nrow=45, ncol=3*num.methods);
  colnames(result.table) <- rep(c('flag', 'cohens.d', 'r2'), num.methods);;

  for (i in 1:45)
  {

    data <- readMat(paste('../', directory, '/', iter, '/', i, '-stat.mat', sep = ''));

    PA <- data$mistakes.list.PA1[,10];
		PANV <- data$mistakes.list.PA1.fea[,10];
    PASL <- data$mistakes.list.PA1.shared[,10];
    #HTLIConline <- data$mistakes.list.HTLIC.online[,10];
    HetOTL <- data$mistakes.list.HetOTL[,10];
    HetOTLshared <- data$mistakes.list.HetOTL.shared[,10];

    OTLHS <- data$mistakes.list.dso[,10];

    result.PA = SignificantTest(PA, OTLHS);
    result.PANV = SignificantTest(PANV, OTLHS);
    result.PASL = SignificantTest(PASL, OTLHS);
    #result.HTLIConline = SignificantTest(HTLIConline, OTLHS);
    result.HetOTL = SignificantTest(HetOTL, OTLHS);
    result.HetOTLshared = SignificantTest(HetOTLshared, OTLHS);

    
		result.table[i,1:3] <- c(result.PA$flag, result.PA$cohens.d, result.PA$r2);
		result.table[i,4:6] <- c(result.PANV$flag, result.PANV$cohens.d, result.PANV$r2);
		result.table[i,7:9] <- c(result.PASL$flag, result.PASL$cohens.d, result.PASL$r2);
		result.table[i,10:12] <- c(result.HetOTL$flag, result.HetOTL$cohens.d, result.HetOTL$r2);
		result.table[i,13:15] <- c(result.HetOTLshared$flag, result.HetOTLshared$cohens.d, result.HetOTLshared$r2);
    
    
  }
  
  write.table(result.table, paste('../process_result', directory, iter, 'significant_test_table', sep = '/'));

  }

}

main(directory)



