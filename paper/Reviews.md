# AMTA 2018 Reviews for Submission \#204

## Remarks from the AMTA 2018 Program Committee
- We would like to invite you to provide a two or three pages version of your paper.
- Please consider renaming your paper as `"System description of ----- from ---- team at DeepHack.Babel task"` (or something that would reflect the contents of your shortened paper.

### Response
+ We have moved the appendices online which immediately cut the paper size by 2 pages.
+ The sample of parallel corpora was also made available online only - a reduction by half a page.
+ Title was changed to `System description of Supervised and Unsupervised NMT approaches from NL Processing team at DeepHack.Babel task`

## REVIEWER \#1
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 1
             Suggested Presentation Type: Poster


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

=== General comments:

The paper discusses a submission to the DeepHack.Babel competition. The authors
analyse how does an unsupervised NMT setting compares to supervised NMT in a
low resource language scenario.

In general, the paper lacks novelty and informativeness. The 4 pages could be
much better used, and I believe much more information could have been provided
which would highlight the strengths and weaknesses of the techniques employed.
The writing is often unclear, and there have been many points while reading the
paper where I did not know what the authors were talking about or why. Finally,
the authors would benefit from English proof-reading by an English native
speaker.

My recommendation is to not accept the manuscript for publication.

=== Detailed comments:

The abstract and introduction do not make it clear why one would like to do
what the authors did. What is the motivation for this work? Why does the
analysis of unsupervised vs. supervised NMT on topic-specific corpora matters?
Are there any industry use-cases that implement this scenario?

In Table 1, the caption does not explain the contents properly. It is unclear
where the results come from, and why they are shown. What is the clear
difference between oblivious vs. conscious "scores"? If it is unsupervised vs.
supervised, that is not clear. If it has to do with the language pair being
unknown at some point, that is also not clear. This is the only table with
results, which according to the caption shows "Supervised NMT Baselines". What
about the results for the unsupervised NMT models?

Regarding the language pair being unknown, much more details are needed. Are
they unknown at training time? If so, do you need to train one model to
translate from all languages into all languages? I assume not. If they are only
unknown at test time, which I believe is the case, how did it affect the
systems and results? That is not sufficiently described.

In Section 2, the authors mention "continuous embeddings" multiple times, which
does not sound correct. The authors also mention a baseline that does "an input
to output copy", which must be explained. Is it just using the input directly
as the output? Or is it a "copy attention" mechanism?

In Section 3, the authors talk about "zero models" without any explanation of
what that might be. This section is very confusing and did not make much sense.

In Section 4, the authors talk about "language pair attacks". What is that?
That is so disconnected from everything else that I could hardly understand
what the authors meant by that. How is that important to your systems? Did you
use these "attacks"? How does using the "attacks" compare to not using them
(i.e. in BLEU scores)? How does using one attack compare versus using the
other? Again, I emphasise that this section is very confusing.

Table 2 shows examples from the corpus, and takes more than half a page in a
4-pages paper. Unfortunately, the manuscript lacks content and does not bring
novel nor important information. It is confusing and unclear, and it needs much
more details. Some examples of crucial points that are missing: the authors
should specify how the different models are trained (NLL loss? Cross-entropy
loss? Minimum risk? Etc.), specially for the unsupervised NMT scenario; what is
the objective function being minimised/maximised there?; how is the data
pre-processed (lowercasing, tokenising, BPE-encoding, etc.).

I suggest the authors look at high-impact Machine Translation papers published
in strong conferences/journals (ACL, EMNLP, CL Journal) and try to infer the
minimum contribution expected for a paper in this field.

## REVIEWER \#2
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 3
             Suggested Presentation Type: Oral


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

The paper describes system for unsupervised machine translation developed
during DeepHack.Babel event. The system itself is a variation of well known
encoder-decoder architecture. Despite lacking of originality in the
architecture, the paper is presenting interesting results in so called
"oblivious" setup.
Also a description of possible attacks would be helpful for future experiments
in oblivious setup.

Major comments:
1) The paper is describing models for MT, but only literally, it would gain
from figures depicting described architectures.
2) The paper is presenting results on corpora which is not publicly accessible.
I suggest the authors to conduct experiments on some well known corpus, like
Europarl, to ease comparison with other systems.
3) Section 3 of the paper is describing unsupervised model, but the results for
it is  not listed in table 1 or anywhere else. It is unclear if it was used or
not in final system for the competition.
4) The supervised system is described with specific set of parameters; it is
not clear from the provided results, if the choice was optimal. I suggest the
authors to conduct few experiments for exploratory study.

Minor remarks:
1) Section 2 is named "Baselines", but it presents only one baseline system.
2) Table 1 shows results for consecutive epochs, but the paper does not contain
any analysis of this data.
3) Section 6 is devoted to corpora description, it seems to be more logical to
place it before Section 4.

Overall, I think this paper could published after proposed improvements are
done and added to the paper.

## REVIEWER \#3
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 1
             Suggested Presentation Type: Poster


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

The paper is a system description paper and explains the system configuration
of the author’s submission to deephack competition.
Here are some minor comments:
Paper needs some proofreading
NL Processing?
Introduction: During => in
I reviewed the the github repo provided for the codes. Codes describe a very
basic model for NMT! Did you use this code repo or used another model for your
submissions?
 Table2: it is also better to add another table and analyze system outputs.
Conclusion: doesn’t really conclude the paper
The paper doesn’t answer the question in the title. Elaborate this with more
details.

### Response
+ `NL Processing` was the team name - sorry, it was very confusing.
+ Fixed problems related to English language usage.
+ We have used more advanced NMT models https://github.com/aoboturov/aoboturov-deephack-babel-qualification in the qualification round.
The competition was about applicability of unsupervised and semi-supervised methods, so we have focused on them.

### TODO
- Conclusion: doesn’t really conclude the paper
- The paper doesn’t answer the question in the title. Elaborate this with more
details.

## REVIEWER \#4
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 1
             Suggested Presentation Type: Poster


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

The paper explore unsupervised and supervised NMT models.

Main issues:
* Define the acronyms: NMT, UNMT etc.
* Why one of the baselines is a copy of the input? A justification for that is
needed.
* I do not understand section 4. Looks like the explanation of how to discover
the language unfairly (maybe cheating?).

Minor issues
* two monolonigual corpora for each language (in Section 1). I guess
you mean that each language has one monolingual corpora.
* Check the format of the tables. Specially Table 3 which has a
different format (there is no line udner the table headers) compared to Table 1
and 2
* Section 3: don't -> do not
* If you give a name "no-Epoch" to the "input to output copy" use it in the
table (instead of "-").

### Response
+ All the acronyms were defined where applicable.
+ Input to Output Copy helps to debug UNMT as is now explained in the UNMT with a dictionary translation zero model subsection.
+ Section 4 indeed explains how someone could work around the oblivious setup constraints.
Although if you look at our models and how they were trained - you would find a proof that we have not done any of it.
Please check our sources https://github.com/aoboturov/loresmt-nlprocessing which are available online.
+ Changed wording for `two monolonigual corpora for each language (in Section 1)`.
+ Changed Table 3 formatting to keep the representation uniform across the paper.
+ Fixed `Section 3: don't -> do not`.
+ Changed model name to `input to output copy`.

## REVIEWER \#5
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 2
             Suggested Presentation Type: Poster


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

The article represents results obtained during the DeepHack.Babel hackathon.
The structure of the article is not absolutely clear. An introduction section
does not provide a general introduction to the field and could be called a
"competition setup".
Section 6 is following section Conclusion what is completely unnatural. It
could be moved to the beginning of the paper.
No related work section.
Table 2 is referred after a reference to table 3. Although appendix provides
more detail information about system architecture, it's hard to understand.
Scheme or figure would be much easy understandable.
Table 1 provides a result of BLUE score for a baseline system but results for
Unsupervised Neural Machine Translation and Supervised Neural Machine
Translation are not provided.
In general, the article contains lack of explanation. What is zero model?
What is word by word model?
The acronyms are not explained.
The cite to PyTorch tool is not provided.
No link to the leaderboard.

Due to this, I'm giving the paper a rating 2.

### Response
+ The intro and data availability and reproducibility sections were reorganized into a Competition Setup section.
+ A link to the leaderboard was provided in a footnote to Competition Setup section.
+ PyTorch was cited as suggested in https://github.com/pytorch/pytorch/issues/4126.
+ The acronyms were explained at the place of first usage.
+ Word by word model is in fact just a dictionary translation, we have changed the explanation there.
+ Zero model is explain in the context of a training epoch for unsupervised model - it would be an initialization for the first epoch.
+ Result for both supervised, semi-supervised and unsupervised models were provided throughout the article, we had regrouped them in Table 2.
+ Fixed table references.

### TODO
- No related work section.
- Although appendix provides more detail information about system architecture, it's hard to understand. Scheme or figure would be much easy understandable.

## REVIEWER \#6
---------------------------------------------------------------------------
Reviewer's Scores
---------------------------------------------------------------------------

                 Originality of the Work: 2
             Suggested Presentation Type: Poster


---------------------------------------------------------------------------
Comments
---------------------------------------------------------------------------

The paper is a bit confusingly written - it not extremely clear how the
unsupervised system performed, given that the results are not in any table,
though the baseline's results are. Did the unsupervised system have a score
less than 0.01? That isn't extremely clear - if it did, what steps were taken
to debug this?

The side-channel attack section is interesting but it isn't clear why execution
time is necessary if a language identification algorithm could be run on the
system - why not just use the output from it straight in the network?

Considering neither of the authors have experience with writing academic
papers, it is quite well-written, however, it could definitely benefit with
more clarity, and attempt to explain results. A Results section would also be
extremely useful, where perhaps the baseline results could be mentioned in a
side-note (they are not as critical as the methods the authors tried to use).
If the unsupervised system's NMT output is indeed invalid, there definitely
needs to be a section attempting to explain why - perhaps the authors could
train the same system on external data outside the hackathon, and artificially
scale down the size of the corpus to see whether the poor performance is truly
because of corpus size.

If the paper is reporting a strongly negative result, this should, if possible,
be made clear in the abstract or the introduction; it is not immediately
obvious that this is the case.

### Response
+ Regarding the language identification - we have expanded introduction to the section `Prior Language Pair Information` to explain that the sheer size of models representations, total training time and amount and diversity of training data would make pre-training a non-viable option.

### TODO
- Explain why we had a strongly negative result for the NMT.
- Explain our attempts to debug the UNMT.
