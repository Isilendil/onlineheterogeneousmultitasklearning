
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

main <- function()
{
  directory <- '../stat/pearson/';

  
  result.PA.extra.table <- matrix(nrow=45, ncol=3*4);
  colnames(result.PA.extra.table) <- rep(c('flag', 'cohens.d', 'r2'), 4);;

  result.PA.extra.sim.table <- matrix(nrow=45, ncol=3*4);
  colnames(result.PA.extra.sim.table) <- rep(c('flag', 'cohens.d', 'r2'), 4);;
  
  for (i in 1:45)
  {

    data <- readMat(paste(directory, i, '-stat.mat', sep = ''));

    PA.personal.image <- data$mistakes.list.PA1.personal.image[,10];
    PA.shared.image <- data$mistakes.list.PA1.shared.image[,10];
    PA.extra.image <- data$mistakes.list.PA1.extra.image[,10];
    PA.extra.sim.image <- data$mistakes.list.PA1.extra.sim.image[,10];

    PA.personal.text <- data$mistakes.list.PA1.personal.text[,10];
    PA.shared.text <- data$mistakes.list.PA1.shared.text[,10];
    PA.extra.text <- data$mistakes.list.PA1.extra.text[,10];
    PA.extra.sim.text <- data$mistakes.list.PA1.extra.sim.text[,10];

    result.PA.extra.image.personal <- SignificantTest(PA.personal.image, PA.extra.image);
    result.PA.extra.image.shared <- SignificantTest(PA.shared.image, PA.extra.image);
    
    result.PA.extra.text.personal <- SignificantTest(PA.personal.text, PA.extra.text);
    result.PA.extra.text.shared <- SignificantTest(PA.shared.text, PA.extra.text);
    

    result.PA.extra.sim.image.personal <- SignificantTest(PA.personal.image, PA.extra.sim.image);
    result.PA.extra.sim.image.shared <- SignificantTest(PA.shared.image, PA.extra.sim.image);
    
    result.PA.extra.sim.text.personal <- SignificantTest(PA.personal.text, PA.extra.sim.text);
    result.PA.extra.sim.text.shared <- SignificantTest(PA.shared.text, PA.extra.sim.text);
    
    
		result.PA.extra.table[i,1:3] <- c(result.PA.extra.image.personal$flag, result.PA.extra.image.personal$cohens.d, result.PA.extra.image.personal$r2);
		result.PA.extra.table[i,4:6] <- c(result.PA.extra.image.shared$flag, result.PA.extra.image.shared$cohens.d, result.PA.extra.image.shared$r2);
		result.PA.extra.table[i,7:9] <- c(result.PA.extra.text.personal$flag, result.PA.extra.text.personal$cohens.d, result.PA.extra.text.personal$r2);
		result.PA.extra.table[i,10:12] <- c(result.PA.extra.text.shared$flag, result.PA.extra.text.shared$cohens.d, result.PA.extra.text.shared$r2);
    
		result.PA.extra.sim.table[i,1:3] <- c(result.PA.extra.sim.image.personal$flag, result.PA.extra.sim.image.personal$cohens.d, result.PA.extra.sim.image.personal$r2);
		result.PA.extra.sim.table[i,4:6] <- c(result.PA.extra.sim.image.shared$flag, result.PA.extra.sim.image.shared$cohens.d, result.PA.extra.sim.image.shared$r2);
		result.PA.extra.sim.table[i,7:9] <- c(result.PA.extra.sim.text.personal$flag, result.PA.extra.sim.text.personal$cohens.d, result.PA.extra.sim.text.personal$r2);
		result.PA.extra.sim.table[i,10:12] <- c(result.PA.extra.sim.text.shared$flag, result.PA.extra.sim.text.shared$cohens.d, result.PA.extra.sim.text.shared$r2);
    
  }
  
  write.table(result.PA.extra.table, 'extra');
  write.table(result.PA.extra.sim.table, 'extra.sim');

}

main()



