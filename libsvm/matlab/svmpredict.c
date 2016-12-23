#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "svm.h"

#include "mex.h"
#include "svm_model_matlab.h"

#ifdef MX_API_VER
#if MX_API_VER < 0x07030000
typedef int mwIndex;
#endif
#endif

#define CMD_LEN 2048

int print_null(const char *s,...) {}
int (*info)(const char *fmt,...) = &mexPrintf;

void read_sparse_instance(const mxArray *prhs, int index, struct svm_node *x)
{
	int i, j, low, high;
	mwIndex *ir, *jc;
	double *samples;

	ir = mxGetIr(prhs);
	jc = mxGetJc(prhs);
	samples = mxGetPr(prhs);

	// each column is one instance
	j = 0;
	low = (int)jc[index], high = (int)jc[index+1];
	for(i=low;i<high;i++)
	{
		x[j].index = (int)ir[i] + 1;
		x[j].value = samples[i];
		j++;
	}
	x[j].index = -1;
}

static void fake_answer(int nlhs, mxArray *plhs[])
{
	int i;
	for(i=0;i<nlhs;i++)
		//Create unpopulated two-dimensional, double-precision, floating-point mxArray
		//A pointer to the created mxArray, if successful.Specify either mxREAL or mxCOMPLEX. If the data you plan to put into the mxArray
		//has no imaginary components, specify mxREAL. If the data has some imaginary components, specify mxCOMPLEX.
		plhs[i] = mxCreateDoubleMatrix(0, 0, mxREAL);
}



//nlhs为输出结果个数，plhs为输出参数，prhs为输入的参数，predict_probability = 0

//[predicted_label, accuracy, decision_values] = svmpredict(testlabel_1, B, model);

void predict(int nlhs, mxArray *plhs[], const mxArray *prhs[], struct svm_model *model, const int predict_probability)
{
	int label_vector_row_num, label_vector_col_num;
	int feature_number, testing_instance_number;
	int instance_index;
	double *ptr_instance, *ptr_label, *ptr_predict_label; 
	double *ptr_prob_estimates, *ptr_dec_values, *ptr;
	struct svm_node *x;
	mxArray *pplhs[1]; // transposed instance sparse matrix
	mxArray *tplhs[3]; // temporary storage for plhs[]

	int correct = 0;
	int total = 0;
	double error = 0;
	double sump = 0, sumt = 0, sumpp = 0, sumtt = 0, sumpt = 0;

	int svm_type=svm_get_svm_type(model);
	int nr_class=svm_get_nr_class(model);
	double *prob_estimates=NULL;

	// prhs[1] = testing instance matrix
	//mxGetM()为矩阵的行数即testing_instance_number特征向量的个数，
	
	feature_number = (int)mxGetN(prhs[1]);
	testing_instance_number = (int)mxGetM(prhs[1]);
	label_vector_row_num = (int)mxGetM(prhs[0]);
	label_vector_col_num = (int)mxGetN(prhs[0]);

	
	//判断输入参数是否标准
	if(label_vector_row_num!=testing_instance_number)
	{
		mexPrintf("Length of label vector does not match # of instances.\n");
		fake_answer(nlhs, plhs);
		return;
	}
	if(label_vector_col_num!=1)
	{
		mexPrintf("label (1st argument) should be a vector (# of column is 1).\n");
		fake_answer(nlhs, plhs);
		return;
	}
	
	
	
	//mxGetPr()获得矩阵指针值
	//ptr_instance为特征向量的指针，ptr_label为标签的指针
	ptr_instance = mxGetPr(prhs[1]);
	ptr_label    = mxGetPr(prhs[0]);

	// transpose instance matrix
	//判断是否为稀疏矩阵
	if(mxIsSparse(prhs[1]))
	{
		if(model->param.kernel_type == PRECOMPUTED)
		{
			// precomputed kernel requires dense matrix, so we make one
			mxArray *rhs[1], *lhs[1];
			rhs[0] = mxDuplicateArray(prhs[1]);
			if(mexCallMATLAB(1, lhs, 1, rhs, "full"))
			{
				mexPrintf("Error: cannot full testing instance matrix\n");
				fake_answer(nlhs, plhs);
				return;
			}
			ptr_instance = mxGetPr(lhs[0]);
			mxDestroyArray(rhs[0]);
		}
		else
		{
			mxArray *pprhs[1];
			pprhs[0] = mxDuplicateArray(prhs[1]);
			if(mexCallMATLAB(1, pplhs, 1, pprhs, "transpose"))
			{
				mexPrintf("Error: cannot transpose testing instance matrix\n");
				fake_answer(nlhs, plhs);
				return;
			}
		}
	}

	//跳过
	if(predict_probability)
	{
		if(svm_type==NU_SVR || svm_type==EPSILON_SVR)
			info("Prob. model for test data: target value = predicted value + z,\nz: Laplace distribution e^(-|z|/sigma)/(2sigma),sigma=%g\n",svm_get_svr_probability(model));
		else
			prob_estimates = (double *) malloc(nr_class*sizeof(double));
	}

	tplhs[0] = mxCreateDoubleMatrix(testing_instance_number, 1, mxREAL);
	
	//跳过
	if(predict_probability)
	{
		
		
		
		
		// prob estimates are in plhs[2]
		if(svm_type==C_SVC || svm_type==NU_SVC)
			tplhs[2] = mxCreateDoubleMatrix(testing_instance_number, nr_class, mxREAL);
		else
			tplhs[2] = mxCreateDoubleMatrix(0, 0, mxREAL);
		
		
		
	}
	else
	{
		//创建决策值的存储空间
		// decision values are in plhs[2]
		if(svm_type == ONE_CLASS ||
		   svm_type == EPSILON_SVR ||
		   svm_type == NU_SVR ||
		   nr_class == 1) // if only one class in training data, decision values are still returned.
			tplhs[2] = mxCreateDoubleMatrix(testing_instance_number, 1, mxREAL);
		else
			
		//每个特征都有nr_class*(nr_class-1)/2个决策值，因为一共进行了nr_class*(nr_class-1)/2次判断
			tplhs[2] = mxCreateDoubleMatrix(testing_instance_number, nr_class*(nr_class-1)/2, mxREAL);
			
			
	}

	//预测的标签
	ptr_predict_label = mxGetPr(tplhs[0]);
	ptr_prob_estimates = mxGetPr(tplhs[2]);
	//决策值
	ptr_dec_values = mxGetPr(tplhs[2]);
	
	//存储一个特征向量的空间，feature_number为特征维数
	x = (struct svm_node*)malloc((feature_number+1)*sizeof(struct svm_node) );
	
	
	//遍历每一个测试样本,分别进行预测
	for(instance_index=0;instance_index<testing_instance_number;instance_index++)
	{
		int i;
		double target_label, predict_label;

		//样本的类别
		target_label = ptr_label[instance_index];

		
		if(mxIsSparse(prhs[1]) && model->param.kernel_type != PRECOMPUTED) // prhs[1]^T is still sparse
			read_sparse_instance(pplhs[0], instance_index, x);
		else
		{
			//对x进行赋值
			for(i=0;i<feature_number;i++)
			{
				x[i].index = i+1;
				x[i].value = ptr_instance[testing_instance_number*i+instance_index];
			}
			//最后一个特征值index为-1
			x[feature_number].index = -1;
		}
		
		
		
		
		//跳过
		if(predict_probability)
		{
			if(svm_type==C_SVC || svm_type==NU_SVC)
			{
				//由于proA和proB为空，则直接返回预测的标签
				predict_label = svm_predict_probability(model, x, prob_estimates);
				
				ptr_predict_label[instance_index] = predict_label;
				
				for(i=0;i<nr_class;i++)
					ptr_prob_estimates[instance_index + i * testing_instance_number] = prob_estimates[i];

			} else {
				
				predict_label = svm_predict(model,x);
				ptr_predict_label[instance_index] = predict_label;
			}
		}

		else
		{
			if(svm_type == ONE_CLASS ||
			   svm_type == EPSILON_SVR ||
			   svm_type == NU_SVR)
			{
				double res;
				predict_label = svm_predict_values(model, x, &res);
				ptr_dec_values[instance_index] = res;
			}
			else
				
			
//**********************************************************************************************************************
			{
				
				double *dec_values = (double *) malloc(sizeof(double) * nr_class*(nr_class-1)/2);
				
				//预测的结果￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥
				predict_label = svm_predict_values(model, x, dec_values);
				
				if(nr_class == 1) 
					ptr_dec_values[instance_index] = 1;
				else
					
					//存放决策值
					for(i=0;i<(nr_class*(nr_class-1))/2;i++)
						
						//instance_index为当前样本index，ptr_dec_values为第三个返回值
						ptr_dec_values[instance_index + i * testing_instance_number] = dec_values[i];
					
					
				free(dec_values);
			}
			
			
			//将预测结果存放到feature_number
			ptr_predict_label[instance_index] = predict_label;
			
			
		}

		//统计正确的个数
		if(predict_label == target_label)
			++correct;
		
		
		error += (predict_label-target_label)*(predict_label-target_label);
		sump += predict_label;
		sumt += target_label;
		sumpp += predict_label*predict_label;
		sumtt += target_label*target_label;
		sumpt += predict_label*target_label;
		++total;
		
		
		
		
		
	}
	if(svm_type==NU_SVR || svm_type==EPSILON_SVR)
	{
		info("Mean squared error = %g (regression)\n",error/total);
		info("Squared correlation coefficient = %g (regression)\n",
			((total*sumpt-sump*sumt)*(total*sumpt-sump*sumt))/
			((total*sumpp-sump*sump)*(total*sumtt-sumt*sumt))
			);
	}
	else
		
	
	
	
	//计算分类的正确率
		info("Accuracy = %g%% (%d/%d) (classification)\n",
			(double)correct/total*100,correct,total);

			
			
	// return accuracy, mean squared error, squared correlation coefficient
	tplhs[1] = mxCreateDoubleMatrix(3, 1, mxREAL);
	
	ptr = mxGetPr(tplhs[1]);
	ptr[0] = (double)correct/total*100;
	ptr[1] = error/total;
	ptr[2] = ((total*sumpt-sump*sumt)*(total*sumpt-sump*sumt))/
				((total*sumpp-sump*sump)*(total*sumtt-sumt*sumt));

	free(x);
	if(prob_estimates != NULL)
		free(prob_estimates);

	//根据svmpredict()函数输出参数个数赋值，3个全部赋值
	switch(nlhs)
	{
		case 3:
			plhs[2] = tplhs[2];
			plhs[1] = tplhs[1];
		case 1:
		case 0:
			plhs[0] = tplhs[0];
	}
}

void exit_with_help()
{
	mexPrintf(
		"Usage: [predicted_label, accuracy, decision_values/prob_estimates] = svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')\n"
		"       [predicted_label] = svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')\n"
		"Parameters:\n"
		"  model: SVM model structure from svmtrain.\n"
		"  libsvm_options:\n"
		"    -b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0); one-class SVM not supported yet\n"
		"    -q : quiet mode (no outputs)\n"
		"Returns:\n"
		"  predicted_label: SVM prediction output vector.\n"
		"  accuracy: a vector with accuracy, mean squared error, squared correlation coefficient.\n"
		"  prob_estimates: If selected, probability estimate vector.\n"
	);
}
/*
整个c程序由一个接口子过程 mexFunction构成
nlhs：输出参数数目 
plhs：指向输出参数的指针 
nrhs：输入参数数目 
mxGetScalar(prhs[0]) ：把通过prhs[0]传递进来的mxArray类型的指针指向的数据（标量）赋给C程序里的变量;
mxGetPr(prhs[0]) :从指向mxArray类型数据的prhs[0]获得了指向double类型的指针
mxGetM(prhs[0]):获得矩阵的行数
mxGetN(prhs[0]):获得矩阵的列数
mxCreateDoubleMatrix(int m, int n, mxComplexity ComplexFlag) :实现内存的申请，m：待申请矩阵的行数 ； n：待申请矩阵的列数*/

 /*  nlhs：mexFunction的第一个参数，它指示Matlab的调用命令中等号左侧有几个变量。例如，code 4中的调用，nlhs的值为2，因为它的等号左侧有两个变量，他们是a和b。
    plhs: mexFunction的第二个参数，它指示Matlab的调用命令中等号左侧变量的指针。例如，code 4中的调用，plhs[0]表示的是a，plhs[1]表示的是b。
    nrhs：mexFunction的第三个参数，它指示Matlab的调用命令中等号右侧的变量个数。例如，code 4中的调用，nrhs的值为2，因为它的等号右侧有两个变量，他们是c和d。
    prhs：mexFunction的第四个参数，它指示Matlab调用命令中等号右侧的变量指针。例如，code 4中的调用，prhs[0]表示的是c，prhs[1]表示的是d。
    mxArrary是一个不可见的数据类型，是Matlab定义的，大家只需要知道mxArrary的指针与Matlab中的变量一一对应就可以了。
	Matlab中的数据是按列存储的。例如，a=[1,2;3,4;5,6]，a的数据在内存中的存储顺序是：1、3、5、2、4、6。在C\C++中使用Matlab传来的变量时，一定要注意数据的存储顺序。*/

	
	
//[predicted_label, accuracy, decision_values] = svmpredict(testlabel_1, B, model);



void mexFunction( int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[] )
{
	int prob_estimate_flag = 0;
	struct svm_model *model;
	info = &mexPrintf;

	
	//nlhs为3，nrhs为3，跳过
	if(nlhs == 2 || nlhs > 3 || nrhs > 4 || nrhs < 3)
	{
		exit_with_help();
		fake_answer(nlhs, plhs);
		return;
	}

	//判断输入的第一和第二个参数是符合类型
	if(!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1])) {
		mexPrintf("Error: label vector and instance matrix must be double\n");
		fake_answer(nlhs, plhs);
		return;
	}

	
	//判断第三个输入参数是不是model
	if(mxIsStruct(prhs[2]))
	{
		const char *error_msg;

		// parse options如果带有参数，分析参数
		if(nrhs==4)
		{
			int i, argc = 1;
			char cmd[CMD_LEN], *argv[CMD_LEN/2];

			// put options in argv[]
			mxGetString(prhs[3], cmd,  mxGetN(prhs[3]) + 1);
			if((argv[argc] = strtok(cmd, " ")) != NULL)
				while((argv[++argc] = strtok(NULL, " ")) != NULL)
					;

			for(i=1;i<argc;i++)
			{
				if(argv[i][0] != '-') break;
				if((++i>=argc) && argv[i-1][1] != 'q')
				{
					exit_with_help();
					fake_answer(nlhs, plhs);
					return;
				}
				switch(argv[i-1][1])
				{
					case 'b':
						prob_estimate_flag = atoi(argv[i]);
						break;
					case 'q':
						i--;
						info = &print_null;
						break;
					default:
						mexPrintf("Unknown option: -%c\n", argv[i-1][1]);
						exit_with_help();
						fake_answer(nlhs, plhs);
						return;
				}
			}
		}

		
		//读取并转换matlab中的model为svm_model结构
		model = matlab_matrix_to_model(prhs[2], &error_msg);
		
		
		
		if (model == NULL)
		{
			mexPrintf("Error: can't read model: %s\n", error_msg);
			fake_answer(nlhs, plhs);
			return;
		}
		
		
		//跳过
		if(prob_estimate_flag)
		{
			if(svm_check_probability_model(model)==0)
			{
				mexPrintf("Model does not support probabiliy estimates\n");
				fake_answer(nlhs, plhs);
				svm_free_and_destroy_model(&model);
				return;
			}
		}
		else
		{
			if(svm_check_probability_model(model)!=0)
				info("Model supports probability estimates, but disabled in predicton.\n");
		}

		//********************************************* prob_estimate_flag=0
		predict(nlhs, plhs, prhs, model, prob_estimate_flag);
		
		// destroy model
		svm_free_and_destroy_model(&model);
	}
	else
	{
		mexPrintf("model file should be a struct array\n");
		fake_answer(nlhs, plhs);
	}

	return;
}
