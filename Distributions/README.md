This folder contains code and other files for the ChapelCon '25 Distributions Demo/Exercise session. 
It also includes a short primer on Chapel arrays.

# Brainstorming
What things should be covered in this demo?
- What is a distribution?
- Why is it useful? 
- How do I create one?
- How does it interact with arrays?
- What functions/features might I use in conjunction with distributions?
- What are some specific use cases?

I'm going to start with the Chapel documentation and hope there's some good starting points there.

First thing I'm realizing is that I also need to be thinking about domains here. This is actually a pretty big set of features to cover in a single demo but I think we can manage it.

In the [BlockDist](https://chapel-lang.org/docs/modules/dists/BlockDist.html) notes, there's a pretty good example that demonstrates a bit how the distribution works. Could be good to show how a couple of different distributions assign ownership.
- BlockDist
- CyclicDist
- BlockCycDist
Some explanation of using StencilDist, even if we don't show the output


Would be good to show using distributions on arrays of aggregate data structures.

For arrays need to show
- declaration
- assignment
- parallel iteration
- promotion
- queries on elements and array itself
- how to get a particular locale's subsection of the array
- reductions


For distributions: how to specify different assignments across locales. `targetLocales`

For domains, need to show: 
- declaring a domain
- `expand` and `exterior` and `interior`

