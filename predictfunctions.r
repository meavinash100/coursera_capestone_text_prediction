#Text Prediction Functions

cleansentense <- function(mysentence){
        mysentence <- gsub("[[:punct:]]", "", mysentence) 
        mysentence <- gsub("[[:digit:]]", "", mysentence) 
        mysentence <- gsub("[ \t]{2,}", "", mysentence) 
        mysentence <- gsub("^\\s+|\\s+$", "", mysentence) 
        mysentence <- gsub("[\r\n]", "", mysentence) 
        mysentence <- str_replace_all(mysentence,"[^[:graph:]]", " ") 
        mysentence <- gsub("[^[:alnum:][:blank:]']", "", mysentence) 
        mysentence <- tolower(mysentence) 
        return(mysentence)
}


processinput <- function(cleanuserinput){ 
        #Counting number of words
        i <- str_count(cleanuserinput, 
                       pattern = " ") 
        i <- i + 1 
        matchpattern <- character(0) 
        if (i > 4){
                matchpattern <- word(cleanuserinput, -4, -1) 
        } 
        else {
                matchpattern <- cleanuserinput
        } 
        return(matchpattern)
}

searchmatch <- function(matchpattern, 
                        mypredictions, 
                        unigram, 
                        bigram,
                        trigram,
                        quadgram,
                        ngram){ 
        i <- integer(0L)
        i <- str_count(matchpattern, 
                       pattern = " ")
        i <- i + 1
        if (i == 4){
                matchngram <- ngramcompare (matchpattern, ngram)
                matchquadgram <- quadgramcompare (matchpattern, quadgram)
                matchtrigram <- trigramcompare (matchpattern, trigram)
                matchbigram <- bigramcompare (matchpattern, bigram)
        }
  
        if (i == 3){
                matchquadgram <- quadgramcompare (matchpattern, quadgram)
                matchtrigram <- trigramcompare (matchpattern, trigram)
                matchbigram <- bigramcompare (matchpattern, bigram)
        }
  
        if (i == 2){
                matchtrigram <- trigramcompare (matchpattern, trigram)
                matchbigram <- bigramcompare (matchpattern, bigram)
        }
  
        if (i == 1){
                matchbigram <- bigramcompare (matchpattern, bigram)
        }

        finalmatch <- data.frame(name = character(), 
                                 freq = integer(), 
                                 last = character(), 
                                 lastbutone = character(), 
                                 stringsAsFactors = FALSE)
        if(exists("matchngram")){
                if (!is.null(matchngram)){
                        #Getting List of Unique ngrams
                        matchngram$nnames <- as.character(matchngram$nnames)
                        matchngram$lastfour <- as.character(matchngram$lastfour)
                        matchngram$lastbutone <- as.character(matchngram$lastbutone)
                        ngramunique <- unique(matchngram$lastbutone)
                        matchngram <- rename(matchngram, 
                                             name = nnames,
                                             freq = nfreq, 
                                             last = lastfour)
                        finalmatch <- rbind(finalmatch, matchngram)
                }
        }
        if(exists("matchquadgram")){
                if (!is.null(matchquadgram)){
                        #Getting List of Unique quadgrams
                        matchquadgram$quadnames <- as.character(matchquadgram$quadnames)
                        matchquadgram$lastthree <- as.character(matchquadgram$lastthree)
                        matchquadgram$lastbutone <- as.character(matchquadgram$lastbutone)
                        quadgramunique <- unique(matchquadgram$lastbutone)
                        matchquadgram <- rename(matchquadgram, 
                                                name = quadnames, 
                                                freq = quadfreq, 
                                                last = lastthree)
                        finalmatch <- rbind(finalmatch, matchquadgram)
                }
        }
        if(exists("matchtrigram")){
                if (!is.null(matchtrigram)){
                        #Getting List of Unique Trigrams
                        matchtrigram$trinames <- as.character(matchtrigram$trinames)
                        matchtrigram$lasttwo <- as.character(matchtrigram$lasttwo)
                        matchtrigram$lastbutone <- as.character(matchtrigram$lastbutone)
                        trigramunique <- unique(matchtrigram$lastbutone)
                        matchtrigram <- rename(matchtrigram,
                                                name = trinames,
                                                freq = trifreq,
                                                last = lasttwo)
                        finalmatch <- rbind(finalmatch, matchtrigram)
                }
        }
        if(exists("matchbigram")){
                if (!is.null(matchbigram)){
                        #Getting List of Unique bigrams
                        matchbigram$binames <- as.character(matchbigram$binames)
                        matchbigram$last <- as.character(matchbigram$last)
                        matchbigram$lastbutone <- as.character(matchbigram$lastbutone)
                        bigramunique <- unique(matchbigram$lastbutone)
                        matchbigram <- rename(matchbigram, 
                                              name = binames, 
                                              freq = bifreq)
                        finalmatch <- rbind(finalmatch, matchbigram)
                }
        }
        if (nrow(finalmatch)){
                weightedmatch <- weightlogic(finalmatch)
                return(weightedmatch)
        } 
        else {
                unigram <- unigram[1:50,]
                unigram <- select(unigram, -unifreq) %>%
                        rename(Suggestion = uninames, 
                               RelevanceScore = punigram)
                return(head(unigram, 50))
        }
}

weightlogic <- function(finalmatch){
        n <- nrow(finalmatch)
        if (n > 50){
                finalmatch <- finalmatch[1:50,]
        }

        quadweight <- 0.55
        triweight <- 0.3
        biweight <- 0.1
        uniweight <- 0.05
        for (counter in 1: length(finalmatch)){
                len <- as.integer(0L)
                len <- str_count(finalmatch$last[counter], pattern = " ")
                len <- len + 1
                if(len == 4){
                        finalmatch$freq[counter] <- quadweight*finalmatch$freq[counter]
                }
                if(len == 3){
                        finalmatch$freq[counter] <- triweight*finalmatch$freq[counter]
                }
                if(len == 2){
                        finalmatch$freq[counter] <- biweight*finalmatch$freq[counter]
                }
                if(len == 1){
                        finalmatch$freq[counter] <- uniweight*finalmatch$freq[counter]
                }
        }
        normalizationfactor <- sum(finalmatch$freq)
        finalsummary <- group_by(finalmatch,
                                 lastbutone) %>%
                summarise(RelevanceScore = sum(freq)*100/normalizationfactor) %>%
                arrange(desc(RelevanceScore)) %>%
                rename(Suggestion = lastbutone)
        
        return(finalsummary)
}

ngramcompare <- function(matchpattern, ngram){
        if (sum(grepl(matchpattern, ngram$lastfour))){
                matchword <- paste( "^", matchpattern, "$", sep = "")
                matchlist <-  filter(ngram, 
                                     grepl(matchword, 
                                           lastfour))
                return (matchlist)
        }
}

quadgramcompare <- function(matchpattern, quadgram){
        if (sum(grepl(word(matchpattern, -3, -1), quadgram$lastthree))){
                matchword <- paste( "^", word(matchpattern, -3, -1), "$", sep = "")
                matchlist <-  filter(quadgram, 
                                     grepl(matchword, 
                                           lastthree))
                return (matchlist)
        }
}

trigramcompare <- function(matchpattern, trigram){
        if (sum(grepl(word(matchpattern, -2, -1), trigram$lasttwo))){
                matchword <- paste( "^", word(matchpattern, -2, -1), "$", sep = "")
                matchlist <-  filter(trigram, 
                                     grepl(matchword, 
                                           lasttwo))
                return (matchlist)
        }
}

bigramcompare <- function(matchpattern, bigram){
        if (sum(grepl(word(matchpattern, -1), bigram$last))){
                matchword <- paste( "^", word(matchpattern, -1), "$", sep = "")
                matchlist <-  filter(bigram, 
                                     grepl(matchword, 
                                           last))
                return (matchlist)
        }
}