#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <cstring> //memset
#include <cmath>
typedef long long ll;
using namespace std;
//업데이트 문을 따로 뽑아낸 버전

ll seg[1 << 21];
int n, m;
void update(int node, int start, int end, int idx, ll change) {//노드 번호 start, end,바꾸는 노드 인덱스, 변환 값 //start,end,idx는 맨아래 배열 인덱스를 나타냄(1~n)
	if (!(start <= idx && idx <= end))return;//start,end 사이에 idx가 없다면 리턴
	seg[node] += change;
	if (start != end) {
		int mid = (start + end) / 2;
		update(node * 2, start, mid, idx, change);
		update(node * 2 + 1, mid + 1, end, idx, change);
	}

}

ll sum(int idx, int start, int end, int left, int right) {
	if (left <= start && end <= right)return seg[idx];
	if (right < start || end < left)return 0;
	int mid = (start + end) / 2;
	return sum(idx * 2, start, mid, left, right) + sum(idx * 2 + 1, mid + 1, end, left, right);
}

int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> n >> m;
	ll size = pow(2, (ll)log2(n) + 1);
	//for (int i = 0; i < n; i++)cin >> seg[size + i];// 트리 맨 아래 값을이 입력될때만 활성화
	for (int i = size - 1; i > 0; i--) seg[i] = seg[i * 2] + seg[i * 2 + 1];//세그먼트 트리 제작

	int a, b, c;
	for (int i = 0; i < m; i++) {
		cin >> a >> b >> c;
		if (a == 1) {
			int idx = size + b - 1;
			ll change = c - seg[idx];
			update(1,1,size,b,change);
			//업데이트시 맨아래 배열 인덱스를 참조하기때문에 전체 세그먼트 트리에서의 인덱스 에서 변환값을 만들고
			//맨아래 리프 노드들을 하나의 배열로 생각해서 1부터~n개의 인덱스중 원래 인덱스 값 넣기 따라서 idx가 아닌 그냥 b를 넣어줌
		}
		else {
			if (b > c) {
				int temp = b;
				b = c;
				c = temp;
			}
			cout << sum(1,1,size,b,c) << "\n";
		}
	}
	return 0;
}
#include <iostream>
#include <utility>
#include <algorithm>
#include <cmath>//max, min
#include <string.h>//memset 헤더
#include <vector>
#include <stack>
typedef long long ll;
using namespace std;

ll seg[1<<21];//루트는 1부터 0을 사용하면 계산시 매우 복잡해지기떄문
int N, M, K;

ll sum(int idx, int start, int end, int left, int right) {
	//탐색 영역이 범위 안일경우 현제 idx의 값 리턴(굳이 더 들어갈필요 없으니 시간단축)(없어도 상관은 없지만 시간을 줄이기 위해 존재)
	if (left <= start && end <= right) return seg[idx];
	if (right < start || end < left)return 0;
	int mid = (start+end) / 2;
	//현제 idx 기준 오른쪽 값과 왼쪽 값을 더해준것을 리턴
	return sum(idx * 2, start, mid, left, right) + sum(idx * 2 + 1, mid + 1, end, left, right);

}



int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);
	cin >> N >> M >> K;
	ll size = pow(2, (ll)log2(N) + 1);//맨밑줄 크기 구하기
	for (int i = 0; i < N; i++) {//트리 맨 밑줄 입력받기
		cin >> seg[size + i];
	}
	for (int i = size - 1; i > 0; i--) {//나머지 윗부분 채우기(맨밑에부터 역순으로)
		seg[i] = seg[i * 2] + seg[i * 2 + 1];//왼쪽 + 오른쪽 인덱스
	}
	for (int i = 0; i < M + K; i++) {
		ll a, b, c;
		cin >> a >> b >> c;
		if (a == 1) {
			ll idx = (size + b - 1);//맨 아랫줄 친구를 바꿔줘야하니까
			ll change = (c - seg[idx]);//위쪽으로 올라가면서 빼줘야 하는값
			seg[idx] = c;//맨밑의 숫자를 변환
			for (idx /= 2; idx > 0; idx /= 2)seg[idx] += change;
            //변환된 수가 양수이면 더해지고 음수이면 뺴짐
		}
		if (a == 2) {
			cout << sum(1, 1, size, b, c) << "\n";
            //시작인덱스(루트 인덱스),맨 아래 배열 시작인덱스,맨 아래 배열 끝 인덱스,구간 시작 인덱스, 구간 끝 인덱스
		}
	}
	return 0;
}
