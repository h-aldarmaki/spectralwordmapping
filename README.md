# About #

A Matlab implementation of the spectral word mapping method described in [Unsupervised Word Mapping Unising Structural Similarities in Monolingual Embeddings](https://arxiv.org/pdf/1712.06961.pdf)

```
@article{TACL1317,
	author = {Aldarmaki, Hanan  and Mohan, Mahesh  and Diab, Mona },
	title = {Unsupervised Word Mapping Using Structural Similarities in Monolingual Embeddings},
	journal = {Transactions of the Association for Computational Linguistics},
	volume = {6},
	year = {2018},
	url = {https://www.transacl.org/ojs/index.php/tacl/article/view/1317},
	pages = {185--196}
}
```


# Instructions #

A sample bash script is available in **fr_en_s** that runs an experiment with k={10,20,30} - 10 runs each. 

```
./fr_en_s/experiment.sh > log/fr_en_s.log
```

* The output of the above experiment is provided as an example. You can examine the output in `fr_en_s/output/` and `log/fr_en_s.log`

* The initial mapping using spectral embeddings will be output to `fr_en_s/output/kxx_xx/spectral_map_kxx.lex`

* The final mapping for each run will be saved in the output directory with `.map.lex` extension.

* According to the log, the best mapping is the 4th run with k=20 `fr_en_s/output/k20_4/`

## Other Datasets ##

* Data for **fr_en_d**, **ar_en_p**, and **ar_en_s** are provided (gunzip the vector files first)

* To run the experiment with other datasets, change the values of `data_dir`, `source`, and `target` in **experiment.sh**


## Evaluation ##

* To project a translation matrix using the extracted pairs, you will need a larger set of word embeddings (we used the top 50K words) and the implementation in [Improving zero-shot learning by mitigating the hubness problem](http://clic.cimec.unitn.it/~georgiana.dinu/down/)

* WordNet train and test sets are available in `dictionaries/`

## Summary of Steps ##
1. Preprocess corpora
    * Tokenize text, lowercase, and normalize digits.
2. Learn monolingual word embeddings using [FastText](https://github.com/facebookresearch/fastText)  
    * `./fasttext skipgram -input data.txt -output model`
3. Extract the top 2000 words from the source and target embeddings, and separate words and vectors (see sample files above). 
1. Modify **experiment.sh** as needed and execute it (this might take one hour per run).
2. Examine the log and pick the run that results in the lowest cost. 
3. Using the (source, target) pairs in the chosen `.map.lex` file, fit a [translation matrix](http://clic.cimec.unitn.it/~georgiana.dinu/down/).
4. Evaluate
