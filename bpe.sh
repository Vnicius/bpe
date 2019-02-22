BPEROOT=subword-nmt
BPE_TOKENS=10000
src=$1
tgt=$2
prep=prep
tmp=$prep/temp

mkdir $prep
mkdir $tmp

cat train.$src train.$tgt > $tmp/train.$src-$tgt

TRAIN=$tmp/train.$src-$tgt
BPE_CODE=$prep/code

echo "learn_bpe.py on ${TRAIN}..."
subword-nmt learn-bpe -s $BPE_TOKENS < $TRAIN > $BPE_CODE

for L in $src $tgt; do
    for f in train.$L valid.$L test.$L; do
        echo "apply_bpe.py to ${f}..."
        subword-nmt apply-bpe -c $BPE_CODE < $f > $prep/$f
    done
done