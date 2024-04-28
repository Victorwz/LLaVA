#!/bin/bash
# pip install -e ./
# pip install -e ".[train]"
# pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2
# pip install flash-attn --no-build-isolation


deepspeed --num_gpus=8 llava/train/train_mem.py  \
    --model_name_or_path /mnt/raid5/weizhi/models/Meta-Llama-3-8B \
    --deepspeed ./scripts/zero3.json \
    --version v3 \
    --data_path /mnt/raid5/weizhi/llava/ablation/llava_instruct_608k_reasoning_20k.json \
    --image_folder /mnt/raid5/weizhi/llava/data/ \
    --vision_tower openai/clip-vit-large-patch14-336 \
    --pretrain_mm_mlp_adapter /mnt/raid5/weizhi/checkpoints/llava-v1.5-llama-3-8b-pretrain-clip-large-336px/mm_projector.bin \
    --mm_projector_type mlp2x_gelu \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --image_aspect_ratio pad \
    --group_by_modality_length True \
    --bf16 True \
    --output_dir /mnt/raid5/weizhi/checkpoints/llava_instruct_608k_reasoning_20k \
    --num_train_epochs 1 \
    --per_device_train_batch_size 4 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 50000 \
    --save_total_limit 1 \
    --learning_rate 2e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 2048 \
    --gradient_checkpointing True \
    --dataloader_num_workers 8 \
    --lazy_preprocess True \
    --report_to none